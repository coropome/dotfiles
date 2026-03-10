# 0001 AI Dev OS Delivery Workflow

- Status: Accepted
- Date: 2026-03-11

## Context

AI Dev OS は dotfiles から AI workspace platform へ広がりつつあり、実装の方向、運用ルール、workflow 追加の粒度をその場の判断に任せると履歴が荒れやすい。

特に次の問題がある。

- backlog と active work の境界が曖昧になる
- 大きい設計判断が commit message だけに埋もれる
- branch と PR が issue に結びつかず、後から追いにくい
- AI runtime と dotfiles runtime の変更が混ざりやすい

## Decision

AI Dev OS の開発は以下の運用で進める。

- idea inbox は [`tasks/backlog.md`](../92-development-workflow.md) に置く
- active work の source of truth は GitHub Issues にする
- 長期影響のある判断は `docs/adr/` に ADR として残す
- 実装は issue に紐づいた feature branch で行う
- PR は issue を close し、必要なら ADR を参照する
- merge 前に `make test` と `make lint` を必須にする

## Consequences

- 変更理由をあとから辿りやすくなる
- multi-agent で並行作業しても work item を分離しやすい
- backlog と architecture decision の責務が明確になる
- issue を作らずに小さく直したい場面でも、最低限 bug/feature の記録が必要になる
