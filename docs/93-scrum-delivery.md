# Scrum Delivery

この repo の active work は issue-first を前提にしつつ、複数ステップにまたがる時は軽量な Scrum cadence で進める。
AI Dev OS の delivery は ad hoc な issue hopping に戻さず、backlog refinement, sprint planning, review/demo, retrospective を明示的に回す。

## Working Agreement

- multi-step work はこのページの cadence に従う
- sprint は issue-backed slice で持つ
- `PLANS.md` は active sprint の restartable source of truth にする
- sprint 中も backlog refinement を止めず、次の候補を粗く整えておく
- review/demo と retrospective を省略して次の sprint に飛ばない
- ただし single-step の小さな変更は、issue-first と verification を満たす最小 ceremony でよい
- retrospective は dead-end note にせず、次の system update と sprint memory まで残す

## Sprint Planning

- 1 sprint で close したい issue を決める
- acceptance criteria のうち今回達成する slice を明確にする
- docs, tests, ADR の有無を先に決める
- parallel lane が必要なら最初に squad を組む

planning の出口は次の状態。

- branch が issue に紐づいている
- `PLANS.md` が current sprint を説明できる
- 誰が product, delivery, review を持つか分かる
- 最小形なら 3 行程度の sprint note でもよい

## Backlog Refinement

- 次の候補を `tasks/backlog.md` で粗く整える
- Problem, Improvement Idea, Expected Impact が短く説明できる状態にする
- issue に切る前に scope が 1 sprint で扱えるかを確認する
- 複数 issue に分けるべきならこの時点で分割する

Definition of Ready:

- problem が 1 段落で説明できる
- goal / non-goals が分かる
- acceptance criteria が testable である
- branch 名の粒度が見えている
- docs / tests / ADR の必要性が見えている

## Execution

- active issue を主語に進める
- 実装前に必要な docs と tests の更新箇所を見積もる
- multi-agent で進める時は write scope を分ける
- sprint 中の判断は `PLANS.md` と issue に戻せる形にする
- context loss や handoff に備えて、lane ごとの要点は `tasks/sprint-memory/` に圧縮して残せる形で集める

## Review / Demo

- diff が sprint goal に対して過不足ないことを示す
- tests / lint の結果を残す
- newcomer-facing change なら docs surface の一貫性も確認する
- demo が必要な change では、実行順や利用者の見え方を説明できる状態にする
- multi-agent sprint では、review/demo までに compressed memory に decisions, lane outcomes, rerun commands を揃える
- PR では `.github/pull_request_template.md` の `Sprint Context` に sprint memory, review/demo, system updates を短く残す

## Retrospective

- keep
  - この sprint で続けるべきやり方
- change
  - 次の sprint で変える進め方
- stop
  - 速度や品質を落としたやり方

retrospective は長文でなくてよいが、次 sprint の backlog refinement や staffing に効く形で残す。
最小形なら keep / change / stop を 1 行ずつ残せばよい。

## Retrospective Feedback Loop

retrospective の出口は「感想」ではなく、どこを更新するかが決まっている状態にする。

- backlog
  - 次 sprint で切る改善候補を `tasks/backlog.md` に足す
- plans
  - `PLANS.md` の squad, risk, memory artifact, resume point を更新する
- docs
  - operating docs や newcomer docs を更新する
- tests
  - durable wording や operating rule を test で固定する
- instructions
  - `AGENTS.md` や compatibility instructions を更新する
- ADR
  - 長期運用判断として記録が必要かを判断する
- no-op
  - 変えるものがなければ、それも retrospective の結果として残す

少なくとも 1 つは「どこに反映したか」を示すか、明示的に no-op を残す。

## Squad Roles

- Product / Backlog
  - issue shape, acceptance criteria, priority, scope split を持つ
  - 必要 skill: product judgment, docs framing, backlog refinement
- Delivery / Scrum
  - sprint commitment, `PLANS.md`, ceremony completion を持つ
  - 必要 skill: execution control, sequencing, risk management
- Implementer
  - main change set を持つ
  - 必要 skill: shell/code/docs editing, integration judgment
- Reviewer / QA
  - regression scan, test coverage, wording drift を持つ
  - 必要 skill: review discipline, verification, risk spotting

必要に応じて specialist lane を追加してよい。

- Docs / Onboarding specialist
- Runtime / Trust specialist
- Platform / OS specialist
- Prompt / Eval specialist

## Staffing Guidance

1 人または 1 agent が複数 role を兼務してよい。
最小 squad は 3 lane だが、small sprint では同じ人が Product / Backlog, Delivery / Scrum, Implementer を兼ねてもよい。

- Product / Backlog
- Delivery / Scrum
- Reviewer / QA

実装がある sprint では Implementer を明示する。
複数 lane が並ぶ時は reviewer を最後に置かず、途中から並走させる。

ceremony の最小成果物は次でよい。

- Sprint Planning
  - issue, branch, acceptance slice を 1 か所に書く
- Backlog Refinement
  - 次候補の Problem / Impact を backlog に足す
- Review / Demo
  - tests と diff summary を残す
- Retrospective
  - keep / change / stop を短く残し、反映先か no-op を書く

## Sprint Memory

compressed sprint memory artifact は `tasks/sprint-memory/` に置く。
`PLANS.md` は live な active-work doc とし、長く残す handoff / memory compression は別 artifact に逃がす。

標準は compressed memory で、full raw chat transcript は標準 artifact にしない。
raw coordination log は次の時だけ optional で残す。

- 意思決定の根拠が要約だけでは落ちる
- 複数 lane の非同期判断を監査したい
- 外部 review 向けに coordination evidence が必要

標準ファイル名:

- compressed memory
  - `tasks/sprint-memory/issue-<id>.md`
- optional raw coordination log
  - `tasks/sprint-memory/raw/issue-<id>.md`

memory artifact の最小項目:

- Sprint
  - issue, branch, date, lanes
- Compressed Memory
  - goal, decisions, constraints, current state, next likely moves, open questions
- Lane Notes
  - Product / Delivery / Review などの短い要約
- Retrospective Output
  - keep, change, stop, follow-ups
- System Updates
  - backlog / plans / docs / tests / instructions / ADR が `updated / not needed / follow-up issue` のどれか
- Handoff
  - next agent が最初に読むもの、rerun commands、known risks

## Definition of Done

- issue exists and the sprint slice matches it
- docs changed if behavior or operating rules changed
- tests changed when behavior or durable wording changed
- `make lint` passes
- `make test` passes
- `PLANS.md` is restartable or intentionally closed out
- review/demo evidence exists
- retrospective note for the sprint exists in issue, PR, or plan closeout
- retrospective output is mapped to backlog, plans, docs, tests, instructions, ADR, or explicit no-op
- multi-agent or handoff-heavy work leaves `tasks/sprint-memory/issue-<id>.md` or explicitly records why one was not needed
