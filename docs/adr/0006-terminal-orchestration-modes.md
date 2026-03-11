# 0006 Terminal Orchestration Modes

- Status: Accepted
- Date: 2026-03-11

## Context

AI Dev OS の primary value は AI workflow routing, vendor-native config との接続, context build, trust boundary, starter onboarding にある。

一方で、現在の `ai start` は tmux に強く依存している。
そのため実装上の backend が、そのまま product boundary に見えやすい。

この構造には 2 つの緊張がある。

- tmux は detach / attach, session persistence, scriptability の面で今でも強い
- しかし Ghostty や WezTerm のような terminal-native surface は、UI や OS integration の面で魅力がある

この repo が durable な AI workspace platform を目指すなら、「AI control plane」と「workspace backend」と「terminal-native frontend integration」を分けて考える必要がある。

## Decision

この repo では、AI Dev OS の control plane と workspace execution surface を分離して扱う。

- AI Dev OS control plane
  - `ai` CLI surface
  - workflow routing
  - agent metadata
  - prompt / context handoff
  - trust guidance
  - starter repo onboarding
- workspace backend
  - long-lived session を実際に立ち上げる実装
  - 現時点の current default workspace backend は tmux
- terminal-native frontend integration
  - Ghostty, WezTerm, iTerm2 などの terminal UI / automation integration
  - backend ではなく optional frontend lane として扱う

tmux は current default workspace backend であり、現時点では `ai start` の実行要件でもある。
しかし tmux 自体を AI Dev OS の north-star product boundary にはしない。

今後の設計原則は次のとおり。

- `ai start` の contract は「AI workspace を開くこと」であって、「tmux を直接 expose すること」ではない
- tmux helper (`tnew`, `tgo`, `tkill`) は host substrate として残してよい
- Ghostty や WezTerm は tmux の即時置き換え対象ではなく、terminal-native frontend integration として評価する
- backend を増やす時は `ai start` の backend adapter を通して増やし、control plane の responsibility は変えない
- beginner path は 1 本に保ち、backend choice を newcomer-facing default decision にしない

## Consequences

- 短期:
  - `ai start` は引き続き tmux-backed workspace launcher として維持する
  - docs では「tmux は current implementation requirement」と「AI surface の本体ではない」を明示する
- 中期:
  - `ai start` に workspace backend adapter を導入し、`tmux` を default backend としつつ別 mode を足せるようにする
  - 最初の alternative backend は `stdio` または terminal-native integration のどちらかで検証する
- 長期:
  - terminal-native frontends が成熟しても、workflow routing / trust / context / starter onboarding は control plane に残す
  - その結果、Ghostty や WezTerm を試しても repo の本質的な product surface はぶれない
