# 0002 AI Dev OS As The Primary Product Surface

- Status: Accepted
- Date: 2026-03-11

## Context

この repository は personal dotfiles から始まったが、現在は AI workflow, starter generation, trust policy, context build, GitHub Actions starter まで含む AI Dev OS runtime として使われている。

一方で、top-level docs や一部の user-facing wording には依然として「dotfiles に AI 機能を足したもの」という framing が残っている。

その結果:

- newcomer には AI Dev OS が add-on に見える
- host bootstrap と AI workflow の責務境界が読み取りづらい
- generated starter や troubleshooting の導線も product surface と substrate が混ざって見える

## Decision

この repository では AI Dev OS を primary product surface として扱う。

dotfiles, tmux, git include, symlink/bootstrap, macOS setup は AI Dev OS を支える host/runtime substrate として位置づける。

具体的には:

- README と newcomer docs は AI Dev OS を主語にする
- architecture / ownership docs は AI Dev OS control plane と host substrate を分けて書く
- user-facing CLI wording は「dotfiles repo を編集する」ではなく「shared AI Dev OS runtime repo を使う」と表現する
- generated guidance では local starter repo と shared runtime repo の境界を明示する

## Consequences

- repository 名が `dotfiles` のままでも、product framing は AI Dev OS に寄せる
- historical dotfiles docs は残してよいが、top-level entrypoint からは host/substrate として説明する
- deeper file moves や repository rename が必要なら別 issue で扱う
- tests は AI Dev OS first の wording を guard する
