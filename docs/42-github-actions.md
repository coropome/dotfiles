# GitHub Actions Starter

`ai init` は default で repo-local override に加えて GitHub Actions の starter も生成する。
全部 skip したい時は `--no-github-actions`、hosted eval だけ外したい時は `--no-hosted-eval` を使う。
generated `.ai-dev-os/README.md` では local onboarding を main path に置き、このページの workflow 操作は optional section として案内する。

starter workflow は shared AI Dev OS runtime を参照する。
現在の shipped default は `coropome/dotfiles` と `main` だが、これは current default source であって product identity ではない。fork / branch / tag に pin して使える。

生成対象:

- `.github/workflows/ai-dev-os-pr.yml`
- `.github/workflows/ai-dev-os-hosted-eval.yml`

`--no-github-actions` の時はこのページの workflow 生成は行わず、next step は `ai doctor` / `ai workflows` / `ai start` が中心になる。
`--no-hosted-eval` の時は `ai-dev-os-pr.yml` だけを生成し、hosted eval は後から opt-in で追加する。

## Which Path To Choose

- local-only で始めたい
  - `ai init --no-github-actions`
  - `ai doctor`
  - `ai workflows`
  - `ai start`
  - まず repo-local onboarding を固め、CI は必要になってから足す
- PR で最低限の smoke check を回したい
  - GitHub Actions starter を残す
  - hosted eval までは要らなければ `--no-hosted-eval`
  - まずは `ai-dev-os-pr.yml` だけで prompt validation と CLI smoke を回す
- hosted eval も使いたい
  - local path と PR smoke が落ち着いてから `ai-dev-os-hosted-eval.yml` を足す
  - credential / usage policy / cost の管理が必要になる前提で opt-in にする
- runtime pinning はいつ要るか
  - upstream default branch 追従で困っていない間は不要
  - fork を使う時、branch で runtime を試す時、upstream drift を止めたい時に `AI_DEV_OS_RUNTIME_REPOSITORY` と `AI_DEV_OS_RUNTIME_REF` を触る
  - CI failure が local onboarding で再現しない時に pinning を疑う

## ai-dev-os-pr.yml

PR 向けの基本 workflow。

- prompt artifact の local validation
- `ai workflows` / `ai agents` / `ai-agent --describe --workflow review` などの CLI smoke test

この workflow は target repo 自体に加えて、AI Dev OS runtime repo も checkout して実行する。
target repo は検査対象、runtime repo は `ai` command と shell test asset の参照元として使う。

runtime checkout は次の env で切り替える。

- `AI_DEV_OS_RUNTIME_REPOSITORY`
- `AI_DEV_OS_RUNTIME_REF`

現在の default runtime source は `coropome/dotfiles` と `main` だが、fork に替えたり、branch / tag / fixed ref に pin して再現性を上げられる。

## ai-dev-os-hosted-eval.yml

Hosted eval 用の optional workflow。

- PR ごとの自動実行はしない
- manual dispatch で必要な時だけ動かす
- `gh models eval` など hosted backend を使う前提

これも target repo と shared AI Dev OS runtime の両方を checkout する。
hosted eval は opt-in とし、credential や usage policy は repo 側で明示的に管理する。
こちらも `AI_DEV_OS_RUNTIME_REPOSITORY` と `AI_DEV_OS_RUNTIME_REF` を使って runtime repo と ref を固定できる。

## 使い分け

- 普段の PR では `ai-dev-os-pr.yml`
- 比較評価や回帰確認を hosted backend で回したい時だけ `ai-dev-os-hosted-eval.yml`

CLI 側の最小説明は `docs/40-cli.md`、beginner 向け導線は `docs/00-quickstart.md` を参照。

## Troubleshooting

- まず local onboarding を先に進めたい
  - `ai init --no-github-actions`
  - `ai doctor`
  - `ai workflows`
  - `ai start`
  - CI が今の問題でないなら generated workflow を追う前に local path を固める
- hosted eval だけまだ不要
  - `ai init --no-hosted-eval`
  - `ai-dev-os-pr.yml` だけで prompt validation と CLI smoke を回す
  - hosted backend や credential が必要になってから `ai-dev-os-hosted-eval.yml` を足す
- generated CI が upstream の変更で急に揺れた
  - `AI_DEV_OS_RUNTIME_REPOSITORY` と `AI_DEV_OS_RUNTIME_REF` を確認する
  - upstream default branch 追従を止めたいなら fixed tag / fixed branch / commit-ish に pin する
  - 再現性を優先する時は `main` ではなく明示 ref を使う
- fork した runtime を使いたい
  - `AI_DEV_OS_RUNTIME_REPOSITORY` を fork に変える
  - `AI_DEV_OS_RUNTIME_REF` も fork 側の branch / tag に合わせる
  - target repo の checkout と runtime repo の checkout は別物として考える
- branch で runtime を試したい
  - `AI_DEV_OS_RUNTIME_REF` を feature branch に向ける
  - branch 検証が終わったら fixed tag か安定 branch に戻す
  - PR 側の変更と runtime 側の変更を同時に疑う時は local path でも再現するか先に見る
- runtime checkout target が間違っていそう
  - workflow 内の `AI_DEV_OS_RUNTIME_REPOSITORY` と `AI_DEV_OS_RUNTIME_REF` を見る
  - default runtime repo (`coropome/dotfiles`) 前提のまま fork 固有の docs / templates / helper を期待していないか確認する
  - CI failure が local onboarding では再現しないなら runtime pinning の問題を先に疑う

## Pinning Patterns

- upstream 追従をそのまま使う
  - `AI_DEV_OS_RUNTIME_REPOSITORY=coropome/dotfiles`
  - `AI_DEV_OS_RUNTIME_REF=main`
- fork を固定で使う
  - `AI_DEV_OS_RUNTIME_REPOSITORY=<owner>/<repo>`
  - `AI_DEV_OS_RUNTIME_REF=<stable-branch-or-tag>`
- branch で試す
  - `AI_DEV_OS_RUNTIME_REF=<feature-branch>`
  - 検証後は stable ref に戻す
- drift を止める
  - tag や固定 ref に pin する
  - local repo 側の workflow 更新タイミングを自分で決める
