# Task and branch alignment

At the start of each task in a Git repository, inspect the current branch, working-tree status, and the user's request before editing.

- Check whether the current branch name and its apparent purpose match the task's intent. Judge semantic alignment, not just whether the branch is non-empty or has a topic prefix. For example, `feat/opencode_branch_intent_check` fits work on branch/task alignment, but not an unrelated package update.
- If the branch clearly matches, continue in the current worktree. Follow-up questions or changes for the same objective do not need a new branch or worktree.
- If the branch is `main`/`master`, its purpose conflicts with the request, or the match is unclear, use a task-specific branch/worktree instead of editing here. The agent may create and switch to that worktree without asking the user for permission.
- Do not enforce this policy with an edit-time plugin, session-ID ownership lock, or automatic association between an OpenCode session and a worktree. `session_move` is not required.
- When using a new branch/worktree, use a descriptive branch name matching the task (for example, `feat/<name>`, `fix/<name>`, or `docs/<name>`). Check for an existing branch/worktree first and follow repository conventions. Base it on the default branch unless the task depends on unmerged work or the user specifies another base.
- Before creating a new worktree, check for uncommitted changes. Never move or copy them implicitly; ask the user if they are needed or the task boundary is unclear.
- Worktrees must always be created under `.git/wt/`.
