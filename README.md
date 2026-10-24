# StackShip demo

How [EZ Game Host](https://github.com/ezgamehost) runs OpenTofu with
[StackShip](https://stackship.run). This repository is a small monorepo with
two stacks, each connected to its own StackShip workspace:

| Directory | Workspace | Trigger path |
| --- | --- | --- |
| [`stacks/network`](stacks/network) | `demo-network` | `stacks/network/**` |
| [`stacks/app`](stacks/app) | `demo-app` | `stacks/app/**` |

The stacks use only the `random` provider and `terraform_data`, so they plan
and apply without any cloud credentials.

## What to look at

- **Checks on `main`.** Every push to `main` that touches a stack starts a
  plan-and-apply run. The commit gets one check per workspace, for example
  `StackShip / demo-app`, which moves from *Plan succeeded* to
  *Apply succeeded* once the plan is approved and applied. See the
  [commit history](../../commits/main).
- **Pull request plans.** A pull request gets a speculative plan for each
  workspace whose files it changes, shown as a check and as a single
  StackShip comment that lists every planned change by resource address. See
  the [pull requests](../../pulls?q=is%3Apr).
- **CI.** [`ci.yml`](.github/workflows/ci.yml) runs `tofu fmt` and
  `tofu validate` alongside the StackShip checks.

No configuration here declares a `cloud` or `backend` block: StackShip keeps
each workspace's state itself.

## Learn more

- [Connect GitHub](https://docs.stackship.run/workspaces/vcs)
- [Run lifecycle](https://docs.stackship.run/runs/lifecycle)
- [Approvals](https://docs.stackship.run/runs/approvals)
