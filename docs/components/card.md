# Card

## Purpose

自己完結したコンテンツ（メトリクス、フォーム、プロフィール概要など）を単一のサーフェスにまとめる。JavaScriptは使わず、背景色・ボーダー・角丸・シャドウ・内側パディングをCSSで適用する。

## Native primitive

- `<article>`（自己完結コンテンツ。見出し付きカードに推奨）
- `<section>`（ページ内の区切りとしてのカード）
- `<div>`（見出しを持たない装飾的なまとまり）

`role` やARIAによるカードの再定義は行わない。文書構造に基づいて要素を選ぶ。

## Required markup

`nv-card` クラスを付与する。

```html
<article class="nv-card">
  <h3>Title</h3>
  <p>自己完結したコンテンツ。</p>
</article>
```

`nv-card` は `> :first-child` / `> :last-child` のマージンを正規化する。カード内の余白はパディングで管理されるため、先頭要素の上マージンと末尾要素の下マージンがパディングと二重にならない。

## Optional classes

`src/60-components.css` に存在するクラスのみを使用する。

- `nv-card` — サーフェス背景 + ボーダー + 角丸 + シャドウ + 内側パディング

カード固有のvariantクラスは存在しない。内部レイアウトには `nv-stack` / `nv-stack-sm` / `nv-cluster` などを併用する。

```html
<article class="nv-card nv-stack-sm">
  <h3>Projects</h3>
  <strong>24</strong>
</article>
```

## Supported interactions

- カード自体にinteractionはない。内部のボタン・リンク・フォーム等がネイティブに動作する
- カード全体をクリック可能にする必要がある場合は、見出しを `<a>` にするなど、ネイティブのリンクで表現する（カード全体にクリックハンドラを付けない）

## Accessibility

- 見出し付きの自己完結コンテンツには `<article>` を使う（支援技術が記事として認識する）
- カード全体をリンクにしない（`<a>` で包まない）。ラベルとなる見出しテキストをリンクにする
- カードは見た目の区切りであり、`role` は追加しない

## Progressive enhancements

- `src/60-components.css` の `box-shadow: var(--nv-shadow-sm)` による軽い影
- `src/70-motion.css` により `prefers-reduced-motion: no-preference` 時のみトランジションが付く

## Fallback behavior

- 背景・ボーダー・角丸・シャドウのみ。CSSなしでもコンテンツは通常のブロックとして表示される
- 高度なCSS機能を必要としない

## Examples

```html
<div class="nv-grid">
  <article class="nv-card nv-stack-sm">
    <span class="nv-text-muted" style="font-size: var(--nv-font-size-sm)">Projects</span>
    <strong style="font-size: var(--nv-font-size-3xl)">24</strong>
    <span class="nv-badge nv-badge-success">+3 this month</span>
  </article>

  <article class="nv-card">
    <h3>Native First</h3>
    <p>ブラウザに適切なネイティブ機能が存在する場合、それを使用する。</p>
    <a href="#">Read more</a>
  </article>
</div>
```

## Anti-patterns

- カード全体を `<a>` やクリックハンドラで包む（リンク・ボタンは内部に置く）
- `role="article"` などを付与する（ネイティブの `<article>` を使う）
- カードのvariantクラス（`nv-card-primary` 等）を発明する
- カードを `position: relative` + 影などの装飾で再実装する
