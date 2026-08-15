# Layout

## Purpose

頻出するレイアウトパターン（縦積み・横並び・グリッド・コンテンツ幅）に、Nativum標準のレイアウトプリミティブを提供する。`nv-` プレフィックス付きの少数のプリミティブのみを定義し、任意のユーティリティクラスを組み合わせて自由にレイアウトする「utility framework」にはしない。

## Native primitive

レイアウトはすべてCSSのFlexbox / Gridで実装する。レイアウト専用のHTML要素は存在しない。

- `<div>` / `<section>` / `<article>` / `<header>` / `<footer>` / `<main>`（任意のコンテナ要素）
- `display: flex`（Stack / Cluster）
- `display: grid`（Grid）
- CSSカスタムプロパティ `--nv-grid-min`（グリッドの最小列幅）

見た目ではなく文書構造（セクション、見出し、記事など）に基づいて要素を選ぶ。

## Required markup

クラスを付与するだけでレイアウトが適用される。`nv-stack` / `nv-stack-sm` / `nv-stack-lg` は単独で縦スタックを作る（`display: flex; flex-direction: column` + `gap`）。

```html
<div class="nv-stack">
  <div>one</div>
  <div>two</div>
</div>

<div class="nv-stack-sm">...</div>
<div class="nv-stack-lg">...</div>

<div class="nv-cluster">
  <button>Cancel</button>
  <button>Save</button>
</div>

<div class="nv-grid">
  <article>...</article>
  <article>...</article>
</div>

<main class="nv-container">...</main>
<main class="nv-container-narrow">...</main>
```

## Optional classes

`src/40-layout.css` に存在するクラスのみを使用する。

- `nv-stack` — 縦方向のflex layout（`display: flex; flex-direction: column; gap: var(--nv-space-4)`）
- `nv-stack-sm` — 単独で縦スタックを作る。間隔は狭め（`gap: var(--nv-space-2)`）
- `nv-stack-lg` — 単独で縦スタックを作る。間隔は広め（`gap: var(--nv-space-6)`）
- `nv-cluster` — 横方向のflexible layout（`flex-wrap` + `align-items: center` + `gap`）
- `nv-cluster-between` — `justify-content: space-between` のみの修飾クラス。`.nv-cluster` と併用する
- `nv-cluster-end` — `justify-content: flex-end` のみの修飾クラス。`.nv-cluster` と併用する
- `nv-grid` — 最小列幅ベースのresponsive grid（`--nv-grid-min` を上書きして列幅を変更）
- `nv-container` — 本文用のコンテンツ幅（`--nv-content-width: 64rem`）
- `nv-container-narrow` — 狭幅コンテンツ（`--nv-narrow-width: 40rem`）

```html
<div class="nv-cluster nv-cluster-between">
  <strong>Title</strong>
  <button>Action</button>
</div>

<div class="nv-grid" style="--nv-grid-min: 22rem">...</div>
```

## Supported interactions

レイアウトプリミティブに固有のinteractionはない。子要素（ボタン、リンク、フォーム等）のネイティブ動作がそのまま機能する。

- Stack / Cluster / Grid は表示のみで、フォーカス順やタブ順を変更しない
- 折り返し（Cluster）や列数の増減（Grid）はコンテナ幅に応じてCSSが自動的に調整する

## Accessibility

- レイアウトのために要素の意味を変えない。見出しを持たない汎用のまとまりは `<div>`、自己完結コンテンツは `<article>`、見出し付きセクションは `<section>` を使う
- 表示順とDOM順を一致させる（`order` 等のCSSで視覚順を変えない）
- `nv-container` / `nv-container-narrow` は中央寄せ + 左右パディングを行うが、ランドマークの意味は付与しない。ページ構造には `<main>` / `<header>` / `<nav>` を適切に使う

## Progressive enhancements

- `src/40-layout.css` の `@layer nativum.layout` に定義された静的ルールのみで、追加のprogressive enhancementは持たない
- `--nv-grid-min` はCSSカスタムプロパティであり、グリッド単位で上書きできる

## Fallback behavior

- すべてCSSのFlexbox / Gridのみで実装されている。CSSが読み込まれない環境では、要素は通常のブロックフローで縦に並ぶ
- `nv-grid` は `repeat(auto-fit, minmax(min(100%, var(--nv-grid-min)), 1fr))` で、`min()` 非対応の古い環境でも単一列のグリッドとして崩れずに表示されることを意図している

## Examples

ページ全体の典型的な構成:

```html
<main class="nv-container-narrow nv-stack-lg" style="padding-block: 3rem 4rem">
  <section class="nv-stack-sm">
    <h1>Settings</h1>
    <p class="nv-text-muted">設定の説明</p>
  </section>

  <section class="nv-grid">
    <article class="nv-card">...</article>
    <article class="nv-card">...</article>
  </section>
</main>
```

## Anti-patterns

- layout primitiveをutility frameworkとして扱い、任意のmargin / padding / 幅を `nv-*` クラスで表現する（Nativumはlayout primitiveのみを提供し、任意のutilityは提供しない）
- `nv-cluster-between` / `nv-cluster-end` を単独で使う（`justify-content` のみの修飾クラスのため `.nv-cluster` と併用する）
- `nv-stack-sm` / `nv-stack-lg` を「`nv-stack` との併用必須」と誤解する（各クラスは単独で縦スタックを作る。異なるのは `gap` のサイズのみ）
- グリッドの列数を固定値で指定しようとする（列数ではなく `--nv-grid-min` の最小列幅で管理する）
- レイアウトのために `role` やセマンティック要素を流用する（構造に基づいて要素を選ぶ）
