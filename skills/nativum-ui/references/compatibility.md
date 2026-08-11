# Browser Capability Policy — Agent向け

Nativumの3段階分類。機能を「必須」「任意」「実験的」に分けて、各primitiveの利用可否を判断するためのガイドライン。

## 3段階分類

### Core — その機能なしではcomponentが成立しないprimitive

利用が必須のprimitive。実装の土台であり、未対応環境のために別実装で置き換えない。

代表例:

- `<button>` / `<input>` / `<select>` / `<textarea>` / `<label>`
- `<form>` とネイティブ検証属性 (`required` / `minlength` / `type="email"` 等)
- `<details>` / `<summary>` + `open` 属性
- `<dialog>` / `::backdrop`
- `<table>` / `<caption>` / `<th scope>`
- `<nav>` / `<ol>` / `<ul>` / `<a>` / `aria-current="page"`
- CSS Grid / Flexbox、CSS Custom Properties、Cascade Layers

### Enhancement — 利用可能ならUI・positioning・motionを改善するが、なくても利用可能

利用すると改善されるが、無くても基本操作とコンテンツが成立する機能。**必須扱いにしてはならない**。

代表例:

- `command` / `commandfor` による宣言的dialog開閉
- Popover API (`[popover]` / `popovertarget` / `popovertargetaction` / `:popover-open`)
- CSS Anchor Positioning (`anchor-name` / `position-anchor` / `anchor()`)
- CSS Transitions / `@starting-style` / discrete transitions (`allow-discrete`)
- `:user-invalid` 疑似クラス
- `light-dark()` 関数、`data-theme` による明示テーマ強制
- `:focus-visible` フォーカスリング
- 行のhoverハイライト、`nv-table-striped` のゼブラ表示

利用方針:

- 基本構造 (Core) の上に「後付け」で書く
- 機能検出は `@supports` でガードする (例: `src/60-components.css` の `@supports (anchor-name: --nv-test) and (top: anchor(top))` ブロック)
- 未対応環境ではデフォルト動作にフォールバックする設計にする。popover非対応環境では `[popover]` 要素はドキュメントフロー内の通常コンテンツとして表示されるため、「内容が永久に隠れる」設計にしない

### Experimental — 仕様または実装が十分成熟していない機能。明示的opt-inのみ

既定では使用しない。使用する場合は、無くても動作が変わらないことを明示的に確認する。

代表例:

- declarative cross-document View Transitions (`@view-transition { navigation: auto }`、`src/70-motion.css` が既定で宣言)

利用方針:

- Nativum既定の記述 (`src/70-motion.css`) に従う
- この機能はprogressive enhancementであり、Nativumの必須動作ではない

## 利用可否の判断ガイドライン

1. 実装に必要なprimitiveを Core / Enhancement / Experimental に分類する
2. Enhancementを「必須」と誤認しない。無い環境でのフォールバック動作を1つ決めてから書く
3. 各component documentには `Required primitives` / `Enhancement primitives` / `Fallback behavior` が記載されている (`docs/components/*.md`)。参考にする
4. 判断に迷ったら、`docs/browser-policy.md` (ブラウザ対応方針の正本) を参照する

## 判定例

| コンポーネント | Core | Enhancement | Fallback |
|---|---|---|---|
| Disclosure | `<details>` / `open` | 矢印のtransition | CSSなしでも開閉可能 |
| Dialog | `<dialog>` | `command` / `commandfor`、enter/exit transition | `open` 属性でのサーバーレンダリング |
| Dropdown | `[popover]` + リンク | Anchor Positioning (`nv-dropdown-*`) | popoverのデフォルト配置 |
| Form | `<input>` 等 + 検証属性 | `:user-invalid`、transition | サーバー側再検証 |
