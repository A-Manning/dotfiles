#!/usr/bin/env nu

# Create a local branch "<remote>/<branch>" that tracks "<remote>/<branch>".
#
# Only proceeds when exactly one remote has the branch and that remote is
# neither "origin" nor "upstream". Otherwise explains why and exits nonzero.
def main [branch: string] {
    let remotes = (^git remote | lines | where {|r| $r != "" })

    let found = ($remotes | where {|r|
        (^git show-ref --verify --quiet $"refs/remotes/($r)/($branch)" | complete).exit_code == 0
    })

    if ($found | is-empty) {
        fail $"no remote has a branch '($branch)'. Have you run git fetch?"
    }

    if ($found | length) > 1 {
        let names = ($found | str join ", ")
        fail $"branch '($branch)' exists on several remotes: ($names)."
    }

    let remote = ($found | first)

    if $remote in ["origin" "upstream"] {
        fail $"branch '($branch)' is only on '($remote)'. This command only handles other remotes."
    }

    let local = $"($remote)/($branch)"
    ^git checkout -b $local --track $"remotes/($remote)/($branch)"

    if $env.LAST_EXIT_CODE != 0 {
        exit $env.LAST_EXIT_CODE
    }

    # Make a plain `git push` send local "<remote>/<branch>" to "<branch>" on the remote.
    let refspec = $"refs/heads/($local):refs/heads/($branch)"
    let existing = (^git config --get-all $"remote.($remote).push" | complete | get stdout | lines)
    if $refspec not-in $existing {
        ^git config --add $"remote.($remote).push" $refspec
    }
}

def fail [msg: string] {
    print -e $"error: ($msg)"
    exit 1
}
