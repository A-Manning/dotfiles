#!/usr/bin/env nu

let full_diff = git --no-pager diff --cached --no-color
let modified_lines = $full_diff
    | lines
    | where {|it|(
        ($it | str starts-with '+') and
        (not ($it | str starts-with '+++'))
    )}
let fixme_lines = $modified_lines | where (str contains -i 'FIXME')

if not ($fixme_lines | is-empty) {
    print "WARNING: Commit Rejected"
    print "Found FIXMEs in this commit:"
    $fixme_lines | each { print }
    exit 1
} else {
    exit 0
}