# Navigation

## Purpose

サイト / アプリの主要ナビゲーション（トップナビ、パンくず、ページネーション、ツールバー）にNativum標準スタイルを適用する。すべてリンク・リスト・ボタンのネイティブ構造で構成する。

## Native primitive

- `<nav>`（`aria-label` で識別）
- `<a>`（ナビゲーション）
- `<ol>` / `<ul>` + `<li>`
- `aria-current="page"`（現在位置のマーキング）
- `<button>`（ツールバーの操作）
- `<div>`（ボタングループ）
- `<nav aria-label>`（名前付きボタングループ）

## Required markup

トップナビ:

```html
<nav class="nv-nav" aria-label="Main">
  <strong>Nativum</strong>
  <a href="/" aria-current="page">Dashboard</a>
  <a href="/projects">Projects</a>
  <a href="/settings">Settings</a>
</nav>
```

パンくず:

```html
<nav aria-label="Breadcrumb">
  <ol class="nv-breadcrumb">
    <li><a href="/">Home</a></li>
    <li><a href="/components">Components</a></li>
    <li aria-current="page">Navigation</li>
  </ol>
</nav>
```

ページネーション:

```html
<nav aria-label="Pagination">
  <ul class="nv-pagination">
    <li><a href="/page/1">Prev</a></li>
    <li><a href="/page/1">1</a></li>
    <li><span aria-current="page">2</span></li>
    <li><a href="/page/3">3</a></li>
    <li><a href="/page/3">Next</a></li>
  </ul>
</nav>
```

ツールバー:

```html
<div class="nv-toolbar">
  <button class="nv-primary">New</button>
  <button>Edit</button>
  <button>Export</button>
</div>
```

名前が必要な場合は `<nav class="nv-toolbar" aria-label="Actions">` を使う（generic な `<div>` の `aria-label` は支援技術に公開されない）。

## Optional classes

`src/60-components.css` に存在するクラスのみを使用する。

- `nv-nav` — 横並びのナビゲーションバー（`flex-wrap` + `aria-current="page"` のアクティブ表示）。リンクスタイルは `.nv-nav > a` と `.nv-nav > .nv-cluster a` のみ。ネストした `[popover] a` / `.nv-dropdown a` には適用しない
- `nv-breadcrumb` — パンくずリスト（`<ol>` に付与。項目間の `/` 区切りをCSSで描画）
- `nv-pagination` — ページネーション（`<ul>` に付与。現在ページは `<span aria-current="page">`）
- `nv-toolbar` — スタイル付きボタングループのバー（`role="toolbar"` は付けない。名前が必要なら `<nav class="nv-toolbar" aria-label="...">` を使う）

レイアウト補助として `nv-cluster` / `nv-cluster-between`（ナビとコンテンツの両端配置）、`nv-stack-sm` を併用できる。

## Supported interactions

- すべての項目はネイティブの `<a>` リンクとして通常のナビゲーション動作（クリック、タブフォーカス、Enterで遷移）
- `aria-current="page"` で現在位置を表示（`nv-nav` では `nv-primary` 色のアクティブ背景、`nv-breadcrumb` / `nv-pagination` では強調テキスト / 塗りつぶし）
- hoverは背景色 / 下線で表現される
- ツールバーは通常のボタングループ（タブ順で操作）

## Accessibility

- 複数の `<nav>` があるページでは必ず `aria-label` で識別する（Main / Breadcrumb / Pagination 等）
- 現在ページには `aria-current="page"` を使う。`aria-current` は真偽値でなく値を持つ属性であり、`aria-current="true"` ではなく `aria-current="page"` と書く
- パンくずは順序が意味を持つため `<ol>` を使う
- ページネーションは `nav` で包み、現在ページは `aria-current="page"` の `<span>`（リンクにしない）で表す
- `.nv-toolbar` は `role="toolbar"` を付けないスタイル付きボタングループ。ボタンは通常のタブ順で操作できる。グループ名が必要な場合は `<nav class="nv-toolbar" aria-label="...">` を使う（generic な `<div>` の `aria-label` は支援技術に公開されないため）
- リンクのテキストは行き先を説明する（「詳細を見る」等の曖昧な文言は避ける）

## Progressive enhancements

- `aria-current="page"` のスタイル（`nv-nav` / `nv-breadcrumb` / `nv-pagination` の各セレクタ）
- hover時の背景 / 下線変化
- `src/70-motion.css` のトランジションは `prefers-reduced-motion: no-preference` 時のみ有効

## Fallback behavior

- すべて標準HTML（`nav` / `a` / `ol` / `ul`）で構成されるため、CSSなしでも通常のリンクリストとして機能する
- ページネーションの表示ページ数など、サーバー側で計算してレンダリングする（クライアント状態は持たない）

## Examples

ナビ + パンくず + ページネーション + ツールバー（`examples/index.html` のパターン）:

```html
<header class="nv-container">
  <nav class="nv-nav" aria-label="Main">
    <strong>Nativum</strong>
    <a href="index.html" aria-current="page">Showcase</a>
    <a href="forms.html">Forms</a>
    <a href="dialog.html">Dialog</a>
  </nav>
</header>

<main class="nv-container">
  <nav aria-label="Breadcrumb">
    <ol class="nv-breadcrumb">
      <li><a href="/">Home</a></li>
      <li><a href="/components">Components</a></li>
      <li aria-current="page">Showcase</li>
    </ol>
  </nav>

  <div class="nv-cluster-between nv-cluster">
    <nav aria-label="Pagination">
      <ul class="nv-pagination">
        <li><a href="#">Prev</a></li>
        <li><a href="#">1</a></li>
        <li><span aria-current="page">2</span></li>
        <li><a href="#">3</a></li>
        <li><a href="#">Next</a></li>
      </ul>
    </nav>

    <div class="nv-toolbar">
      <button class="nv-primary">New</button>
      <button>Edit</button>
      <button>Export</button>
    </div>
  </div>
</main>
```

## Anti-patterns

- `<div>` + クリックハンドラでナビゲーションを再実装する（`<a href>` を使う）
- `href="#"` のダミーリンクを量産する（実URLをサーバー側で生成する）
- 現在ページのマーキングをクラスやCSS（`.active` 等）で行う。`aria-current="page"` が状態の唯一の真実源であり、スタイルはそれにのみ依存する（`src/60-components.css` の `.nv-nav > a[aria-current="page"]` / `.nv-nav > .nv-cluster a[aria-current="page"]` セレクタ）
- パンくずに `<ul>`（順序なしリスト）を使う（順序を持つため `<ol>`）
- ページネーションの現在ページを `<a>` にする（`<span aria-current="page">` を使う）
- JS フリーのボタングループに `role="toolbar"` を付ける（toolbar ロールは矢印キーによるフォーカス管理を要求する。タブ順で操作するボタングループには付けない）
- タブUI（Tabs）をナビゲーションリンクの見た目で「実装できる」と誤解させる。TabsはUnsupported
