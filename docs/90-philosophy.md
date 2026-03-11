# 設計思想（AI Dev OS）

AI Dev OS は、初心者にはわかりやすく、手慣れた人には深く速く使い込めて、1年後も日常的に使い続けられる OS レベルの AI workspace platform を目指す。

shell / tmux / git / bootstrap は重要だが、あくまで AI workflow を支える host substrate として扱う。

## 1) 迷ったら AI workflow の入口に戻れる

- beginner の primary entrypoint は `ai start`
- starter repo では `ai init -> ai doctor -> ai workflows -> ai start` を最短導線にする
- tmux helper や bootstrap 手順は必要な時だけ見せる

## 2) host substrate は薄く、でも逃げ道は消さない

- tmux を直接触る人向けに `tnew` や標準 `tmux` command は残す
- shell / git / clipboard / open wrapper も host substrate として提供する
- ただし newcomer にはそれらを main product surface として見せない

## 3) beginner path は明快に、advanced path は深く残す

- いきなり tmux や shell の細部を覚えなくても、`ai start` から作業に戻れる
- その上で tmux を知っている人には標準操作と互換的に読める挙動を残す
- AI workflow も trust / fallback / starter CI などの強い機能は opt-in で段階導入する

## 4) OS レベルの基盤として、道具は薄くつなぐ

- shell / tmux / git / clipboard / open helper は日常作業の基盤として扱う
- ただし user-facing surface は AI workflow の入口を優先し、内部実装を前に出しすぎない
- 慣れた利用者が標準ツールにそのまま降りられる構成を保つ

## 5) 壊れにくさを runtime と host の両方で優先する

- vendor-native config は vendor に寄せ、AI Dev OS は orchestration layer に寄せる
- host bootstrap は symlink / backup / restore の境界を docs で明示する
- generated starter や troubleshooting でも local repo と shared runtime repo の境界を曖昧にしない

## 6) 一過性ではなく、日常の基盤として育てる

- 一時的な workflow wrapper ではなく、毎日の作業で自然に使い続けられる形を優先する
- 流行りの個別機能より、戻りやすさ、移行しやすさ、壊れにくさを優先する
- 1年後に見ても docs と設定の責務分離が崩れていない状態を目指す

## 7) macOS-first だが、AI workflow surface を中心に整理する

- host bootstrap と desktop integration は macOS-first で提供する
- 一方で starter repo onboarding, prompt/trust/workflow docs, CI starter は AI Dev OS の surface として整理する
- Linux / WSL は bootstrap ではなく runtime reference / best-effort health check として扱う

## 8) AIエージェント時代の前提

- 「ログを見る」「差分を見る」「すぐ戻れる」ことが生産性になる
- trust policy, fallback, prompt artifact, staged adoption のような運用上の境界を先に固定する
