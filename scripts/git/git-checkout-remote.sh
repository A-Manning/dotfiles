#!/usr/bin/env nu

# Given a git remote name and branch name:
# * Add a fetch rule for the remote branch to '.git/config'
# * Run `git fetch` for that branch
# * Create a branch named `<remote>/<branch>`, that tracks `<remote>/<branch>`,
#   and switch to it.
#   Ie.,`git switch -c "${REMOTE}/${BRANCH}" --track "${REMOTE}/${BRANCH}"`
# * Add a push rule for the created local branch to '.git/config', that pushes
#   to `<remote>/<branch>`.

def expect-ok [err_msg: string] {
    if $env.LAST_EXIT_CODE != 0 {
        error make { msg: err_msg }
    }
}

def main [remote: string, branch: string] {
    let local = $"($remote)/($branch)"
    let fetch_spec = $"+refs/heads/($branch):refs/remotes/($remote)/($branch)"
    let push_spec = $"refs/heads/($local):refs/heads/($branch)"
    git config --add $"remote.($remote).fetch" $fetch_spec
    expect-ok "failed to add fetch rule"
    git fetch $remote $fetch_spec
    expect-ok $"failed to fetch ($remote)/($branch)"
    git switch -c $local --track $"($remote)/($branch)"
    expect-ok $"failed to create and switch to ($local)"
    git config --add $"remote.($remote).push" $push_spec
    expect-ok "failed to add push rule"
}
