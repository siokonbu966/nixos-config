# Gitea Actions checks, runs and logs

Source: [official gt agent skill](https://gitea.com/gitea/cli/src/branch/main/skills/gt/references/monitoring.md). The installed CLI's help is authoritative if flags differ.

Gitea reports CI on a PR as statuses on the PR's head commit. A check URL may link directly to an Actions job.

## Check status

```sh
gt pr checks 12 --no-input
gt pr checks 12 --no-input --json name,state,description,url
```

Exit code is 0 when checks pass, 1 when one fails, and 8 while checks are pending. `state` values include `success`, `skipped`, and `pending`; other states such as `failure` and `error` are not successful. Re-check after pushing: earlier results are for the old commit.

```sh
gt pr checks 12 --watch --no-input
gt pr checks 12 --watch --timeout 20m --no-input
```

Prefer `--watch` rather than polling in a loop. If jobs remain queued or waiting for approval, report that state rather than waiting indefinitely. `gt runner list --json name,status,labels` shows repository runners; org and instance runners may also serve the repository.

## Find a run

```sh
gt run list --branch feature/login -L 5 --no-input --json id,workflow,status,conclusion,commit
gt run list --commit "$(git rev-parse HEAD)" --no-input --json id,workflow,conclusion
gt run view 34 --no-input --json status,conclusion,jobs
gt run jobs 34 --no-input --json id,name,conclusion,steps
```

Use `--status` to filter by status/conclusion (for example `queued`, `in_progress`, `waiting`, `success`, `failure`, `cancelled`). A run can be identified by its ID or URL; a job URL selects that job.

## Read logs

```sh
gt run logs 34 --failed --no-input
gt run logs 34 --job build --no-input
gt run logs https://gitea.example/OWNER/REPO/actions/runs/34/jobs/71 --no-input
gt run logs 34 --output logs.zip --no-input
```

Logs go to stdout and job names to stderr. For large logs, search or read the tail before loading everything:

```sh
gt run logs 34 --failed --no-input | grep -n -i -E 'error|fail|panic' | tail -n 100
```

An external CI check URL is not a Gitea Actions log and cannot be inspected with `gt run logs`.

## Retry and artifacts

Reruns and cancellations affect shared CI state; perform them only when the user requested it. Prefer retrying only failed jobs when a run is completed and appears flaky.

```sh
gt run rerun 34 --failed --no-input
gt run cancel 34 --no-input
gt run artifact list 34 --no-input --json name,size_in_bytes,expired
gt run download 34 --name build --dir dist --no-input
```
