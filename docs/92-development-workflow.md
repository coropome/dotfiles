# Development Workflow

AI Dev OS の変更は、思いついた順に直接 main へ積むのではなく、`backlog -> issue -> branch -> PR` の順で扱う。

agent 向けの master instruction は [`AGENTS.md`](./../AGENTS.md) に置く。
agent-specific compatibility file がある場合も、基本方針は `AGENTS.md` を source of truth とする。
この repo では `CLAUDE.md` と `GEMINI.md` は `AGENTS.md` への互換エントリとして扱う。

## Source Of Truth

- [`tasks/backlog.md`](./../tasks/backlog.md)
  - 粗いアイデア、調査メモ、改善候補の置き場
  - まだ着手しない内容もここに置いてよい
- GitHub Issues
  - 着手する単位の source of truth
  - 実装・修正・調査は issue を作ってから始める
- [`docs/adr/`](./adr/)
  - 長く残る設計判断の記録
  - 仕様、運用ルール、権限方針、OS abstraction のような継続的判断を残す
- Pull Requests
  - 実装差分と review の置き場
  - 必ず issue に紐づける

## Rules

- active work は GitHub Issue を基準に管理する
- `tasks/backlog.md` は idea inbox であり、active sprint board ではない
- 実装前に agent は `AGENTS.md` を読む
- 実装は issue を作ってから始める
- 実装前に acceptance criteria を issue に書く
- 振る舞い、構造、運用ルールに長期影響がある変更は ADR を書く
- branch 名は issue と目的が分かる形にする
- PR には `Closes #<issue>` を書く
- behavior change がある場合は docs を更新する
- merge 前に `make test` と `make lint` を通す

大きめの仕事や複数ステップの active work は、free-form に進めず [`docs/93-scrum-delivery.md`](./93-scrum-delivery.md) の cadence に従う。
つまり backlog refinement, sprint commitment, review/demo, retrospective を repo ルールとして回す。
一方で single-step の小さな変更まで ceremony を肥大化させる必要はなく、issue-first と test/lint を満たした最小運用でよい。
retrospective の出力は note で終わらせず、必要なら backlog, plans, docs, tests, instructions, ADR へ反映し、圧縮した handoff は `tasks/sprint-memory/issue-<id>.md` に残す。

## Recommended Labels

- `type:feature`
- `type:bug`
- `type:docs`
- `type:chore`
- `area:ai-runtime`
- `area:workflow`
- `area:context`
- `area:os-layer`
- `area:tmux`
- `area:docs`
- `priority:p0`
- `priority:p1`
- `priority:p2`

## Workflow

1. アイデアを [`tasks/backlog.md`](./../tasks/backlog.md) に書く
2. 着手する時に GitHub Issue を作る
3. 必要なら ADR を追加する
4. issue 番号付き branch を切る
5. 実装、テスト、docs 更新を行う
6. PR を作って `Closes #<issue>` を付ける
7. review 後に merge する

## Scrum Cadence For Multi-Step Work

issue-first workflow を守りつつ、multi-step work は軽量な Scrum cadence で回す。

- Sprint Planning
  - 今回の sprint で close する issue と acceptance slice を決める
- Backlog Refinement
  - 次の候補を `tasks/backlog.md` で整え、Problem / Improvement / Impact を粗く揃える
- Execution
  - `PLANS.md` を restartable に保ち、必要なら multi-agent lane を明示する
- Review / Demo
  - diff, tests, docs 更新で何を達成したかを示す
- Retrospective
  - 次に keep / change / stop することを短く残し、必要なら backlog / docs / tests / agent instructions / ADR に反映する

詳細な squad roles, Definition of Ready, Definition of Done は [`docs/93-scrum-delivery.md`](./93-scrum-delivery.md) を参照。
small sprint では 1 人が複数 role を兼務してよい。
context loss や handoff が起こる work では、compressed sprint memory artifact を `tasks/sprint-memory/issue-<id>.md` に残す。

## Branch Naming

- `feat/<issue>-short-name`
- `fix/<issue>-short-name`
- `docs/<issue>-short-name`
- `chore/<issue>-short-name`

例:

- `feat/123-ai-eval`
- `fix/145-ai-start-tmux-check`
- `docs/151-contribution-rules`

## When To Write An ADR

次のいずれかに当てはまる場合は ADR を追加する。

- CLI surface を増減させる
- workflow engine の責務を変える
- vendor integration 方針を変える
- permission / trust policy を変える
- macOS-first と portability の境界を変える
- tmux layout や startup contract を変える

ADR は `docs/adr/NNNN-short-title.md` で追加する。

## Minimal Issue Template

feature issue には少なくとも次を書く。

- Problem
- Goal
- Non-goals
- Proposal
- Acceptance Criteria

bug issue には少なくとも次を書く。

- Summary
- Environment
- Reproduction
- Expected Behavior
- Logs / Evidence

## PR Expectations

- change summary が短く明確
- linked issue がある
- 必要なら linked ADR がある
- tests / lint の結果がある
- rollout risk が書かれている

Scrum cadence で進めた work では、PR summary から sprint memory, review/demo evidence, retrospective-driven system updates が辿れる状態を保つ。
`.github/pull_request_template.md` の `Sprint Context` はその最小入力面で、small change なら `n/a` で済ませてよい。
