# Navigation

## 目的

主要ナビゲーション (トップナビ、パンくず、ページネーション、ツールバー) に標準スタイルを適用する。すべてリンク・リスト・ボタンのネイティブ構造で構成する。

## ネイティブprimitive

- `<nav>` (`aria-label` で識別)
- `<a>` (ナビゲーション)
- `<ol>` / `<ul>` + `<li>`
- `aria-current="page"` (現在位置のマーキング)
- `<button>` (ツールバーの操作)
- `<div>` (ボタングループ)
- `<nav aria-label>` (名前付きボタングループ)

## Required markup

```html
<nav class="nv-nav" aria-label="Main">
  <strong>Nativum</strong>
  <a href="/" aria-current="page">Dashboard</a>
  <a href="/projects">Projects</a>
</nav>

<nav aria-label="Pagination">
  <ul class="nv-pagination">
    <li><a href="/page/1">Prev</a></li>
    <li><a href="/page/1">1</a></li>
    <li><span aria-current="page">2</span></li>
    <li><a href="/page/3">Next</a></li>
  </ul>
</nav>
```

## Nativum classes

このSkillの references/ に記載されたもののみ:

- `nv-nav` — 横並びのナビゲーションバー (`flex-wrap`、`aria-current="page"` のアクティブ表示)
- `nv-breadcrumb` — パンくずリスト (`<ol>` に付与。`/` 区切りをCSSで描画)
- `nv-pagination` — ページネーション (`<ul>` に付与。現在ページは `<span aria-current="page">`)
- `nv-toolbar` — スタイル付きボタングループのバー (`role="toolbar"` は付けない。名前が必要なら `<nav class="nv-toolbar" aria-label="...">` を使う)

レイアウト補助: `nv-cluster` / `nv-cluster-between`, `nv-stack-sm`。

## 動作 (ネイティブのinteraction)

- 全項目はネイティブの `<a>` リンクとして動作 (クリック / タブフォーカス / Enterで遷移)
- `aria-current="page"` が状態の唯一の真実源で、スタイルはそれにのみ依存
- ツールバーは通常のボタングループ (タブ順で操作)

## フォールバック

- 標準HTMLのみで構成されるため、CSSなしでも通常のリンクリストとして機能
- ページネーションのページ数などはサーバー側で計算してレンダリングする

## Anti-patterns

- `<div>` + クリックハンドラでナビゲーションを再実装
- 現在ページのマーキングをクラス (`.active` 等) で行う (`aria-current="page"` を使う)
- パンくずに `<ul>` を使う (順序があるため `<ol>`)
- ページネーションの現在ページを `<a>` にする (`<span aria-current="page">`)
- JSフリーのボタングループに `role="toolbar"` を付ける (矢印キーでのフォーカス管理を要求するため)
- タブUI (Tabs) をナビゲーションの見た目で提供する (Unsupported)

## 詳細

この Skill 内の該当 section が正本。リポジトリの `docs/components/` は人間向けの詳細版。
