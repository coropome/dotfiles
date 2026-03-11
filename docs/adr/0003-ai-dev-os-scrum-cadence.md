# 0003 AI Dev OS Scrum Cadence

- Status: Accepted
- Date: 2026-03-11

## Context

AI Dev OS は issue-first, plan-aware な delivery へ寄せてきたが、複数ステップの active work はまだ実質的に ad hoc な運転に寄りやすい。

その結果:

- backlog refinement が後回しになりやすい
- active sprint と next queue の境界が曖昧になる
- review/demo と retrospective が暗黙になりやすい
- multi-agent work の staffing と skill coverage が人依存になる

## Decision

AI Dev OS の multi-step work は lightweight Scrum cadence で進める。

具体的には:

- sprint planning, backlog refinement, review/demo, retrospective を repo-level ceremony として明示する
- `PLANS.md` を active sprint の restartable artifact として使う
- `tasks/backlog.md` は refinement 前の inbox 兼 next queue として使う
- active delivery の詳細ルールは `docs/93-scrum-delivery.md` に置く
- squad roles と specialist lanes を文書化し、parallel work の staffing を明示する

## Consequences

- active work の進め方が issue-first workflow の上にもう一段そろう
- 「どこから着手し、どこで振り返るか」が repo ルールとして辿りやすくなる
- plan, issue, PR, retrospective のつながりを後から追いやすくなる
- ただし process の重量が増えすぎないよう、small changes まで ceremony を強制しない運用判断は必要になる
