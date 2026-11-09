# `gt api` fallback

Source: [official gt agent skill](https://gitea.com/gitea/cli/src/branch/main/skills/gt/references/api.md). Prefer a typed `gt` command when one covers the operation; the API fallback has fewer safeguards.

`gt api` authenticates with the selected account and sends requests to `/api/v1` on the selected instance. The instance's `/api/swagger` describes its API.

```sh
gt api user --jq .login
gt api 'repos/{owner}/{repo}' --jq .default_branch
gt api 'repos/{owner}/{repo}/issues' -f title="Crash on start"
gt api -X PATCH 'repos/{owner}/{repo}/issues/17' -f state=closed
```

`{owner}`, `{repo}`, and `{branch}` may be inferred from the selected repository and current branch. Write them explicitly when the target must not depend on the current directory. GET is the default; fields normally select POST with a body unless `-X` specifies otherwise. `-f key=value` sends a string, while `-F key=value` parses typed values such as booleans, numbers, arrays and objects. `--input` supplies a request body from a file or stdin.

For list endpoints, `--paginate` follows pages; combine it with `--jq` to flatten results. `--slurp` wraps pages in one JSON array and cannot be combined with `--jq`.

## Write safety

Writes through `gt api` bypass `gt`'s command-level confirmations. Before any POST, PATCH, PUT or DELETE, show the exact method, endpoint and payload and get explicit user approval. Do not use `--sudo` to impersonate another user unless the user explicitly requests it and has authorized that access.
