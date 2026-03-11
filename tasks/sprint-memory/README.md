# Sprint Memory

このディレクトリは multi-step work や multi-agent work の compressed memory artifact を置く。
`PLANS.md` は live な active-work doc とし、ここは handoff と context-loss 耐性のための圧縮記録を残す場所にする。

## When To Write One

- 複数 agent が並走した
- handoff が入る
- context loss が起きやすい長めの作業だった
- retrospective の結果を次 sprint に確実につなぎたい

single-step の小さな変更では不要なこともある。

## File Naming

- compressed memory
  - `issue-<id>.md`
- optional raw coordination log
  - `raw/issue-<id>.md`

raw log は標準 artifact にしない。
標準は compressed memory で、必要な時だけ raw coordination log を optional で残す。

## Raw Log vs Compressed Memory

- compressed memory
  - 次の agent が再開するための正本
  - goal, decisions, constraints, current state, next likely moves を短く残す
- raw coordination log
  - 判断差分の監査や failure analysis が必要な時だけ残す
  - full chat transcript を常時保存する運用にはしない

## Minimal Format

## Sprint

- issue
- branch
- date
- lanes

## Compressed Memory

- goal
- decisions
- constraints
- current state
- next likely moves
- open questions

## Lane Notes

- Product / Backlog
- Delivery / Scrum
- Implementer
- Reviewer / QA

## Retrospective Output

- keep
- change
- stop
- follow-ups

## System Updates

- backlog
- plans
- docs
- tests
- instructions
- ADR

各項目は `updated / not needed / follow-up issue` のどれかで残す。

## Handoff

- next agent が最初に読むもの
- rerun commands
- known risks
