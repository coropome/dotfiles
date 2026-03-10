# Development Workflow

AI Dev OS の変更は、思いついた順に直接 main へ積むのではなく、`backlog -> issue -> branch -> PR` の順で扱う。

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
- 実装前に acceptance criteria を issue に書く
- 振る舞い、構造、運用ルールに長期影響がある変更は ADR を書く
- branch 名は issue と目的が分かる形にする
- PR には `Closes #<issue>` を書く
- behavior change がある場合は docs を更新する
- merge 前に `make test` と `make lint` を通す

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
