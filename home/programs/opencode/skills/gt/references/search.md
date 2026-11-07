# Search and list Gitea resources

Source: [official gt agent skill](https://gitea.com/gitea/cli/src/branch/main/skills/gt/references/search.md). Check `gt <command> --help` for the installed version.

Use `gt issue list` and `gt pr list` to query one repository. Use `gt search issue`, `gt search pr`, and `gt search repo` to search across the selected instance, owner, or repository. `gt` does not provide code search.

```sh
gt issue list --label bug --state open -L 100 --no-input --json number,title,state
gt issue list -S "panic on start" --no-input --json number,title,url
gt pr list --author @me --state open --no-input --json number,title,head,review_decision
gt search issue "login error" --owner OWNER --no-input --json repository,number,title,url
gt search pr --review-requested --no-input --json repository,number,title,url
gt search repo cli --owner gitea --no-input --json full_name,description
```

Search text is a plain query; use flags such as `--label`, `--author`, and `--state` rather than GitHub-style query qualifiers like `is:open`. `@me` is supported by relevant issue/PR list filters. Search results stop at `-L` (30 by default), so raise the limit or paginate before saying nothing exists. Empty result sets still exit successfully.

## Current work and notifications

```sh
gt status --no-input --json pull_requests,assigned_issues,mentions,failing_runs
gt pr status --no-input --json current_branch,authored,review_requested
gt notification list --no-input --json id,repository,type,number,title,unread
```

Notification IDs are thread IDs, not issue numbers; use the listed `number` and `repository` to identify the item. `gt notification view` marks a notification as read, so use `list` when only inspecting.
