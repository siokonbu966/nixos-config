# Issues, pull requests, comments, reviews and repositories

Source: [official gt agent skill](https://gitea.com/gitea/cli/src/branch/main/skills/gt/references/resources.md). Check the relevant `gt <command> --help` for the installed version.

Issue and pull-request numbers share one sequence per repository. Commands generally accept a number, `#number`, or URL; PR commands can also default to the current branch's PR.

## Issues

```sh
gt issue view 17 --no-input --json number,title,body,state,labels,assignees
gt issue comment list 17 -L 100 --no-input --json id,author,body,created_at
gt issue timeline 17 --no-input --json type,author,body,created_at
gt issue list --label bug --state open -L 50 --no-input --json number,title,labels
gt issue create --no-input --title "Crash on empty config" --json number,url --body-file - <<'EOF'
Steps to reproduce, expected and actual behavior.
EOF
```

The `comments` JSON field is a count. Read actual comment text with `gt issue comment list`. Closing/reopening is visible to others and may not ask for confirmation; do it only when the user requests it. Deleting is irreversible.

## Pull requests

```sh
gt pr view 18 --no-input --json title,body,state,base,head,mergeable,review_decision,reviews
gt pr comment list 18 -L 100 --no-input --json id,author,body,created_at
gt pr diff 18 --no-input
gt pr status --no-input --json current_branch,review_requested
```

Use `gt pr diff` or `gt pr view` to inspect. `gt pr checkout` changes the working tree; ask first if switching branches could disrupt current work.

Create a PR only when requested, and ask before pushing a branch that is not already remote:

```sh
gt pr create --no-input --title "fix: explain the change" --body-file - <<'EOF'
Explain what changed and why.

Closes #17
EOF
```

When creating a PR, follow repository contribution instructions and templates. `Closes #17` closes the issue when the PR merges.

## Comments and reviews

```sh
gt issue comment 17 --no-input --body-file - <<'EOF'
Comment text in Markdown.
EOF
gt pr review 18 --approve --no-input --body "Looks good."
```

Reviews and comments are public, user-attributed actions. Only submit the requested review/comment after confirming its content and target. Inline review comments require a file of JSON comments located on changed diff lines:

```json
[
  {"path": "src/main.go", "body": "This also needs an empty-input case.", "new_position": 42}
]
```

`new_position` is a line in the new file; `old_position` is a line in the old file. Exactly one is required per comment.

## Merge

Merging and branch cleanup are irreversible. Only merge when the user explicitly asks, and verify that the required checks/reviews and target are correct first:

```sh
gt pr merge 18 --squash --delete-branch --no-input --yes
```

## Other resources

```sh
gt repo view --no-input --json full_name,default_branch,private,actions_enabled
gt release list -L 5 --no-input --json tag,title,draft,published_at
gt wiki list --no-input --json title
```

Repository settings, releases, tags and wiki pages are shared state. Create or modify them only when requested. For exact flags and available commands, use `gt repo --help`, `gt release --help`, or `gt wiki --help`.
