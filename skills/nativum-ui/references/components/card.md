# Card

## 目的

自己完結コンテンツを単一サーフェスにまとめる。背景・ボーダー・角丸・シャドウ・パディングをCSSで適用する。

## ネイティブprimitive

- `<article>` (自己完結コンテンツ。見出し付きカードに推奨)
- `<section>` (ページ内の区切り)
- `<div>` (見出しを持たない装飾的なまとまり)

`role` やARIAによるカードの再定義はしない。

## Required markup

```html
<article class="nv-card">
  <h3>Title</h3>
  <p>自己完結したコンテンツ。</p>
</article>
```

`> :first-child` / `> :last-child` のマージンを正規化するため、カード内の余白はパディングで管理される。

## Nativum classes

このSkillの references/ に記載されたもののみ:

- `nv-card` — サーフェス背景 + ボーダー + 角丸 + シャドウ + 内側パディング

variantクラスは存在しない。内部レイアウトに `nv-stack` / `nv-stack-sm` / `nv-cluster` を併用する。

```html
<article class="nv-card nv-stack-sm">
  <h3>Projects</h3>
  <strong>24</strong>
</article>
```

## 動作 (ネイティブのinteraction)

- カード自体にinteractionはない。内部のボタン・リンク・フォームがネイティブに動作する
- カード全体をクリック可能にするには、見出しを `<a>` にする等ネイティブのリンクで表現する

## フォールバック

- 背景・ボーダー・角丸・シャドウのみ。CSSなしでもコンテンツは通常のブロックとして表示される

## Anti-patterns

- カード全体を `<a>` やクリックハンドラで包む
- `role="article"` を付与する (`<article>` を使う)
- variantクラス (`nv-card-primary` 等) を発明する

## 詳細

この Skill 内の該当 section が正本。リポジトリの `docs/components/` は人間向けの詳細版。
