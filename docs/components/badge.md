# Badge

## Purpose

短い状態ラベル（ステータス、件数、分類など）を小さなインライン要素で表現する。色だけに依存せず、常にテキストで意味を伝える。

## Native primitive

- `<span>`（インラインの状態表示）
- `<output>`（計算結果の出力として意味を持つ場合）

`role` による再実装はしない。badgeは非インタラクティブな状態表示である。

## Required markup

`nv-badge` クラスを付与する。中性のラベルは `nv-badge` 単体、色付きはvariantを併用する。

```html
<span class="nv-badge">Neutral</span>
<span class="nv-badge nv-badge-primary">Primary</span>
```

## Optional classes

`src/60-components.css` に存在するクラスのみを使用する。

- `nv-badge` — 基本のbadge（subtle背景 + ボーダー + 角丸）
- `nv-badge-primary` / `nv-badge-success` / `nv-badge-warning` / `nv-badge-danger` — ソリッド背景 + `--nv-color-on-*` の文字色

variantはソリッドな背景色と `--nv-color-on-*` の文字色を組み合わせ、light / dark 双方で WCAG AA (4.5:1) のコントラストを保証する（`src/20-tokens.css` の `*-strong` トークン）。

```html
<span class="nv-badge nv-badge-success">Ready</span>
<span class="nv-badge nv-badge-danger">Unsupported</span>
```

## Supported interactions

- badge自体にinteractionはない。クリックやフォーカスを必要としない状態表示である
- 中にアイコンを置く場合は `aria-hidden="true"` の装飾として扱う

## Accessibility

- 色だけに依存しない。常に可視テキストを併記する（「Ready」「3件」など）
- badgeは静的な状態表示であり、`role="status"` / `aria-live` を単体に付けない（動的な状態変化の通知は `nv-notice` を使う）
- badge内のテキストは短く保つ

## Progressive enhancements

- `border-radius: var(--nv-radius-full)` によるピル型
- `src/70-motion.css` により `prefers-reduced-motion: no-preference` 時のみトランジションが付く

## Fallback behavior

- 背景色・ボーダー・角丸のみ。CSSなしでもテキストはそのまま表示される
- `white-space: nowrap` によりテキストが折り返さない

## Examples

```html
<div class="nv-cluster">
  <span class="nv-badge">Neutral</span>
  <span class="nv-badge nv-badge-primary">Primary</span>
  <span class="nv-badge nv-badge-success">Success</span>
  <span class="nv-badge nv-badge-warning">Warning</span>
  <span class="nv-badge nv-badge-danger">Danger</span>
</div>
```

テーブル内の状態表示:

```html
<td><span class="nv-badge nv-badge-success">Active</span></td>
<td><span class="nv-badge nv-badge-danger">Suspended</span></td>
```

## Anti-patterns

- 色だけで状態を伝える（テキストを必ず併記する）
- badgeをボタンやリンクとして使う（`<button>` / `<a>` を使う）
- `<div role="status">` をbadgeとして使う（`<span class="nv-badge">` を使う）
- 状態表示（成功/失敗等）のためにボタンの装飾を独自に増やす（`nv-badge` を使う）
- badgeのvariantクラスを発明する（`nv-badge-neutral` 等は存在しない。中性は `nv-badge` 単体）
