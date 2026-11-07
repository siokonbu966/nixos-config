# Scripts and CI with `gt`

Source: [official gt agent skill](https://gitea.com/gitea/cli/src/branch/main/skills/gt/references/automation.md). Check `gt help environment` and the installed command help for current behavior.

## Non-interactive commands

- Pass `--no-input` to make scripts fail instead of prompting or opening an implicit editor/browser. Do not pass `--editor` or `--web` in automation.
- Use `--json` and `--jq` for machine-readable output. `gt schema [command]` prints available fields with types.
- `GITEA_CLI_ERROR_FORMAT=json` makes errors one JSON line on stderr. Branch on exit codes rather than parsing human-readable text.
- Gitea write operations generally support `--dry-run` to print intended write requests without sending them. It is not supported for `gt pr create`, which may push a branch.
- Use `--yes` only for a specific action the user authorized; it bypasses confirmation, not consent.

## CI credentials

Supply credentials through the CI secret store as environment variables:

```sh
GITEA_CLI_HOST=https://gitea.example.org
GITEA_TOKEN=<provided by the CI secret store>
GITEA_CLI_REPO=OWNER/REPO
```

`GITEA_INSTANCE_URL` can be used instead of `GITEA_CLI_HOST`; `GITEA_CLI_REPO` is optional when repository inference is reliable. Environment credentials are not saved to `config.yml` or `hosts.yml`. Never print, expose, commit, or pass a token as a command-line argument. Do not enable insecure TLS verification except for an explicitly named test instance.

## Workflow dispatch

Dispatch only when requested, and verify the workflow, ref and inputs before triggering it. The workflow must declare `workflow_dispatch`.

```sh
gt workflow list --no-input --json id,name,path,state
gt workflow run ci.yml --ref main -f target=staging --no-input --json id,url
gt workflow run nightly --follow --no-input
```

The `--ref` usually defaults to the current or default branch; inputs use repeated `-f key=value` flags. See `gt workflow run --help` for current options.

## Aliases

Aliases modify the user's local CLI configuration. Create, edit, or remove an alias only when requested.

```sh
gt alias list --no-input
gt alias set failing 'run list --status failure -L 10'
```
