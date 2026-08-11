# Table

## Purpose

データテーブルにNativum標準スタイルを適用する。ストライプ表示と横スクロールラッパーを提供する。テーブルはセマンティックな `<table>` 構造で書く。

## Native primitive

- `<table>` / `<caption>` / `<thead>` / `<tbody>` / `<tr>` / `<th>` / `<td>`
- `<th scope="col">` / `<th scope="row">`（見出しとデータの関連付け）

## Required markup

`scope` 属性で見出しとデータを関連付ける。

```html
<table>
  <caption>Component status</caption>
  <thead>
    <tr>
      <th scope="col">Component</th>
      <th scope="col">Primitive</th>
      <th scope="col">Status</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">Dialog</th>
      <td><code>&lt;dialog&gt;</code></td>
      <td>Ready</td>
    </tr>
  </tbody>
</table>
```

`<th scope="col">` は列見出しとして必須。行見出しの場合は `<th scope="row">` を使う。`caption` でテーブルの説明を与える。

## Optional classes

`src/60-components.css` に存在するクラスのみを使用する。

- `nv-table-striped` — 奇数行の背景色（`tbody tr:nth-child(odd)`）
- `nv-table-scroll` — テーブルを包む横スクロールラッパー（`overflow-x: auto`。カード等の幅制限の中でテーブルがはみ出す場合に使用）

```html
<div class="nv-table-scroll">
  <table class="nv-table-striped">
    ...
  </table>
</div>
```

カード内に置く場合は `nv-card` を併用できる。

## Supported interactions

- テーブル自体に独自のインタラクションはない。行のhoverハイライト（`tbody tr:hover`）が `src/60-components.css` で定義される
- 横スクロールは `nv-table-scroll` のラッパーによるネイティブスクロール
- セル内にリンク・ボタン・バッジ等を置ける（ネイティブ要素のまま）

## Accessibility

- 列見出しは `<th scope="col">`、行見出しは `<th scope="row">` を必ず付ける（`examples/index.html` / `examples/dashboard.html` のパターン）
- `caption` でテーブルの内容を説明する
- 見出しはスタイル上 `text-transform: uppercase` になるが、マークアップは見出しのまま（読み上げが変化しないよう小文字のまま書く）
- テーブルをレイアウト用途に使わない。テーブルはデータ表示専用
- 状態（Active / Invited / Suspended 等）は `nv-badge` とその色で表現する（色だけに依存しない）

## Progressive enhancements

- `nv-table-striped` のゼブラ表示
- `tbody tr:hover` の行ハイライト
- `src/70-motion.css` のトランジションが `prefers-reduced-motion: no-preference` 時のみ有効

## Fallback behavior

- 標準HTMLのみで構成されるため、CSSなしでもデータは読める
- `nv-table-scroll` は `overflow-x: auto` のラッパーであり、スクロール非対応の環境でもテーブルは折り返さず表示される（はみ出しはページスクロールで対処できる）
- 高度なCSS（`text-transform` 等）がなくてもデータ構造は失われない

## Examples

ストライプ + 横スクロール（`examples/dashboard.html` のパターン）:

```html
<article class="nv-card">
  <div class="nv-cluster-between nv-cluster">
    <h2>Team</h2>
    <span class="nv-badge">4 members</span>
  </div>
  <div class="nv-table-scroll">
    <table class="nv-table-striped">
      <thead>
        <tr>
          <th scope="col">Member</th>
          <th scope="col">Role</th>
          <th scope="col">Status</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <th scope="row">Hanako Tanaka</th>
          <td>Owner</td>
          <td><span class="nv-badge nv-badge-success">Active</span></td>
        </tr>
        <tr>
          <th scope="row">Taro Yamada</th>
          <td>Developer</td>
          <td><span class="nv-badge nv-badge-warning">Invited</span></td>
        </tr>
        <tr>
          <th scope="row">Jiro Sato</th>
          <td>Designer</td>
          <td><span class="nv-badge nv-badge-danger">Suspended</span></td>
        </tr>
      </tbody>
    </table>
  </div>
</article>
```

## Anti-patterns

- `<table>` をレイアウト（カラム分割等）に使う
- `<th>` に `scope` を付けない（スクリーンリーダーが見出しとデータの関連を推測できなくなる）
- `<div>` ベースのグリッドでテーブルを再実装する
- ソート機能を「実装できる」と誤解させる（ソート・並べ替えはUnsupported。クライアントJSが必要）
- セル内に `<div role="button">` を置く（`<button>` を使う）
- `caption` を省略する（テーブルの意味が伝わらない）
- 見出しを視覚的装飾のためだけに `<td>` で書く（`<th scope="col">` を使う）
