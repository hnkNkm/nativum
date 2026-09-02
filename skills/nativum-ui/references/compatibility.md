# Browser Capability Policy — Agent向け

Nativumの3段階分類。機能を「必須」「任意」「実験的」に分けて、各primitiveの利用可否を判断するためのガイドライン。

**分類の正本はリポジトリの `docs/browser-policy.md`。** このSkillはvendor後に単独で使えるよう、その分類をここへ同期している。

## 3段階分類

### Core — その機能なしではcomponentが成立しないprimitive

Nativumのcomponent API / native interactionの土台として扱うprimitive。未対応環境では各component referenceに記載されたフォールバックへ縮退し、別のJS UI runtimeでNativum component自体を再実装しない。

代表例:

- `<button>` / `<input>` / `<select>` / `<textarea>` / `<label>`
- `<form>` とネイティブ検証属性 (`required` / `minlength` / `type="email"` 等)
- `:user-invalid` と `[aria-invalid="true"]` による検証状態表現
- `<details>` / `<summary>` + `open` 属性 + `name` 属性によるネイティブ排他グループ
- `<dialog>` / `<dialog open>` / `::backdrop`
- Popover API (`[popover]` / `popovertarget` / `popovertargetaction` / `:popover-open`)
- `<table>` / `<caption>` / `<th scope>`
- `<nav>` / `<ol>` / `<ul>` / `<a>` / `aria-current="page"`
- `color-scheme`
- `:focus-visible`
- CSS Grid / Flexbox、CSS Custom Properties、Cascade Layers

### Enhancement — 利用可能ならUI・positioning・motionを改善するが、なくても利用可能

利用すると外観・positioning・motion等が改善されるが、無くても基本操作とコンテンツが成立する機能。必須動作として独自再実装しない。

代表例:

- `command` / `commandfor` (`show-modal` / `close` / `request-close`) — Dialog の宣言的開閉。未対応では `<dialog open>` + ページ内フォーム
- CSS Anchor Positioning (`anchor-name` / `position-anchor` / `anchor()`)
- CSS Transitions / `@starting-style` / discrete transitions (`allow-discrete`)
- `accent-color`
- `light-dark()`（`src/20-tokens.css` のカラートークン。`@supports (color: light-dark(#000, #fff))` ガード内で使用し、ガード外に静的なライト値フォールバックを宣言。未対応環境ではライト配色へフォールバック）
- `text-wrap: balance` / `text-wrap: pretty`
- `dvh`
- `appearance: none` によるselectのカスタム表示
- Container Queries（v0.1の実装では未使用。将来導入時もEnhancement）

利用方針:

- Core構造の上へ後付けする
- 必要な機能検出は `@supports` 等を使う
- 未対応環境のフォールバックを先に確認する
- Enhancementを成立条件にしない

### Experimental — 仕様または実装が十分成熟していない機能。明示的opt-inのみ

既定では使用しない。ホストアプリケーションが明示的にopt-inし、無くても基本動作が変わらないことを確認する。

代表例:

- declarative cross-document View Transitions (`@view-transition { navigation: auto; }` — Nativum Coreは既定で宣言しない)

## 利用可否の判断ガイドライン

1. 該当component referenceを読む
2. primitiveを Core / Enhancement / Experimental に分類する
3. Coreが未対応の場合はdocumented fallbackを使い、Nativum componentをCSS/JS hackで再実装しない
4. Enhancementは無くても内容・基本操作が維持されることを確認する
5. Experimentalはhost側の明示opt-in以外で有効化しない

## 判定例

| コンポーネント | Core | Enhancement | Fallback |
|---|---|---|---|
| Disclosure / Accordion | `<details>` / `<summary>` / `open` / `name` | chevron transition | `details[name]` 非対応の古い環境でも独立disclosureとして操作可能 |
| Dialog | `<dialog>` / `<dialog open>` | `command` / `commandfor`、enter/exit transition | `<dialog open>` + ページ内フォーム (`examples/dialog.html` フォールバック節) |
| Popover | Popover API | enter/exit transition | フロー内コンテンツとして表示 |
| Dropdown | Popover API + 通常リンク/ボタン | CSS Anchor Positioning | popoverのデフォルト配置 |
| Form | native controls + validation + `:user-invalid` / `[aria-invalid]` | `accent-color` 等 | サーバー側再検証、UA既定表示 |
| Button | `<button>` + `:focus-visible` | transition | UA既定ボタン |

## Popover accessibility note

`popovertarget` を持つネイティブinvokerは、対象popoverとの暗黙のアクセシビリティ関係とexpanded stateをブラウザが提供する。独自 `aria-expanded` stateを手動同期しない。

Nativumの標準dropdownは通常のリンク / ボタンの集合でありARIA `menu` widgetではないため、role-lessなリンクリストpopupへ `aria-haspopup="true"` を付けない (`true` は `menu` と同義)。
