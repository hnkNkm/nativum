# Table

## 目的

データテーブルに標準スタイルを適用する。ストライプ表示と横スクロールラッパーを提供する。テーブルはセマンティックな `<table>` 構造で書く。

## ネイティブprimitive

- `<table>` / `<caption>` / `<thead>` / `<tbody>` / `<tr>` / `<th>` / `<td>`
- `<th scope="col">` / `<th scope="row">` (見出しとデータの関連付け)

## Required markup

```html
<table>
  <caption>Component status</caption>
  <thead>
    <tr>
      <th scope="col">Component</th>
      <th scope="col">Status</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">Dialog</th>
      <td>Ready</td>
    </tr>
  </tbody>
</table>
```

`scope` は列見出し・行見出しに必須。`caption` でテーブルの説明を与える。

## Nativum classes

`src/60-components.css` に存在するもののみ:

- `nv-table-striped` — 奇数行の背景色 (ゼブラ表示)
- `nv-table-scroll` — 横スクロールラッパー (`overflow-x: auto`。幅制限内でテーブルがはみ出す場合に使用)

```html
<div class="nv-table-scroll">
  <table class="nv-table-striped">
    ...
  </table>
</div>
```

カード内に置く場合は `nv-card` を併用できる。

## 動作 (ネイティブのinteraction)

- テーブル自体に独自のインタラクションはない。行のhoverハイライトのみ
- 横スクロールは `nv-table-scroll` のネイティブスクロール
- セル内にリンク・ボタン・バッジ (`nv-badge` 等) をネイティブ要素のまま置ける

## フォールバック

- 標準HTMLのみで構成されるため、CSSなしでもデータは読める
- スクロール非対応環境でもテーブルは表示され、はみ出しはページスクロールで対処できる

## Anti-patterns

- `<table>` をレイアウト (カラム分割等) に使う
- `<th>` に `scope` を付けない
- ソート・並べ替え機能を実装する (NativumでUnsupported。クライアントJSが必要)
- `caption` を省略する

## 詳細

詳細は `../../../../docs/components/table.md` を参照。
