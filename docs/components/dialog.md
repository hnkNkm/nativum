# Dialog

## Purpose

ネイティブの `<dialog>` 要素でモーダル / ノンモーダルのダイアログを実現する。開閉はHTML Standardの `command` / `commandfor` 属性で宣言的に行う。カスタムモーダル実装は禁止。

## Native primitive

- `<dialog>` / `<dialog open>`
- `commandfor` + `command="show-modal"` / `command="show"` / `command="close"` / `command="hide"`
- `<form method="dialog">`（submitでdialogを閉じ、値を `close()` へ渡す）
- `::backdrop`
- `cancel` / `close` イベント（Esc操作等、ブラウザ内部動作）

## Required markup

`commandfor` でトリガーとダイアログを結び、`command="show-modal"` でモーダル表示、`command="close"` で閉じる。

```html
<button commandfor="settings" command="show-modal">Open settings</button>

<dialog id="settings">
  <header>
    <h2>Settings</h2>
  </header>

  <form action="#" method="post">
    <div class="nv-field">
      <label for="d-name">Display name</label>
      <input id="d-name" name="name" type="text" required>
    </div>
  </form>

  <footer>
    <button commandfor="settings" command="close">Close</button>
    <button class="nv-primary" type="submit" form="settings">Save</button>
  </footer>
</dialog>
```

`header` / `footer` は `src/60-components.css` の要素セレクタでスタイルされる。`dialog` 自体に専用クラスは存在しない。

## Optional classes

`dialog` 固有のNativumクラスは存在しない（`dialog` / `header` / `footer` / `::backdrop` は要素セレクタで自動スタイル）。内部レイアウトには以下を併用できる。

- `nv-field` — ダイアログ内フォームのフィールドグループ
- `nv-primary` / `nv-danger` — フッターの主要アクション / 破壊的操作ボタン
- `nv-cluster` / `nv-stack-sm` — レイアウト補助
- `nv-container-narrow` — ページ全体の幅制限

## Supported interactions

すべてブラウザのネイティブ動作である。

- `commandfor` + `command="show-modal"` でモーダル表示（トップレイヤー + 背景の `inert` 化 + フォーカストラップ）
- `command="show"` / `command="hide"` でノンモーダル表示 / 非表示
- `command="close"` で閉じる
- Escキーでキャンセル（`cancel` イベント）
- `<form method="dialog">` の submit でダイアログを閉じ、フォーム値を `close(returnValue)` へ渡す
- `dialog[open]` でサーバーレンダリングされた初期表示
- `::backdrop` クリックでの自動破棄はネイティブの `<dialog>` には**存在しない**。その動作にはJavaScriptが必要であり、Nativumは提供しない

## Accessibility

- `show-modal` はモーダル性（背景 `inert`、フォーカストラップ、Escキャンセル）をブラウザが保証する
- ダイアログにアクセシブルネームを与えるため、`header` 内に `<h2>` 等の見出しを置く
- 見出しを付けたくない場合は `aria-labelledby` を使用する（ネイティブ要素なので `role="dialog"` は不要）
- 背景が `inert` になるため、ダイアログ外のフォーカス移動は構造的に不可能。独自のfocus trapは実装しない
- モーダルの開閉状態はスクリーンリーダーに通知される。`aria-modal` 等の手動付与は不要

## Progressive enhancements

- `command` / `commandfor` による宣言的開閉（HTML Standard定義）。未対応環境では動作しないため、下記フォールバックが必要
- 表示 / 非表示のフェードとスケールは `src/70-motion.css` の `@starting-style` + `allow-discrete` transition（`prefers-reduced-motion: no-preference` 時のみ）
- `::backdrop` の半透明背景とフェード

## Fallback behavior

`commandfor` 未対応環境では、`examples/dialog.html` の推奨パターンに従う。

1. `<dialog>` を `open` 属性付きでサーバーレンダリングする（初期表示を保証）
2. 操作対象を `commandfor` の代わりにページ内の通常フォームへ置き換える（`<form method="dialog">` は未対応環境でも従来のフォームとして機能しうる範囲でフォールバックさせる）

```html
<!-- 未対応環境向け: サーバー側で open を付けてレンダリングする -->
<dialog id="settings" open>
  <header>
    <h2>Settings</h2>
  </header>
  <form action="/settings" method="post">
    ...
  </form>
  <footer>
    <button type="submit" form="settings">Save</button>
  </footer>
</dialog>
```

高度なCSS機能（transition、`@starting-style`）が利用できなくても、ダイアログの表示・操作・意味は維持される。

## Examples

モーダルダイアログ（`examples/dialog.html` / `examples/dashboard.html` のパターン）:

```html
<div class="nv-cluster">
  <button commandfor="settings" command="show-modal">Open settings</button>
</div>

<dialog id="settings">
  <header>
    <h2>Settings</h2>
  </header>
  <form action="/settings" method="post">
    <div class="nv-field">
      <label for="s-name">Display name</label>
      <input id="s-name" name="name" type="text" value="Hanako" required>
    </div>
  </form>
  <footer>
    <button commandfor="settings" command="close">Cancel</button>
    <button class="nv-primary" type="submit" form="settings">Save changes</button>
  </footer>
</dialog>
```

確認ダイアログ（`form method="dialog"`）:

```html
<button commandfor="confirm" command="show-modal">Request confirmation</button>

<dialog id="confirm">
  <header>
    <h2>Delete project?</h2>
  </header>
  <p>この操作は取り消せません。</p>
  <footer>
    <button type="submit" form="confirm-form">Cancel</button>
    <button class="nv-danger" type="submit" form="confirm-form" name="action" value="delete">Delete</button>
  </footer>
</dialog>
<form method="dialog" id="confirm-form" hidden></form>
```

ノンモーダルダイアログ:

```html
<button commandfor="inspector" command="show">Show inspector</button>
<button commandfor="inspector" command="hide">Hide inspector</button>

<dialog id="inspector">
  <header>
    <h2>Inspector</h2>
  </header>
  <p>モーダルではないため、背後にあるページと並行して操作できる。</p>
  <footer>
    <button commandfor="inspector" command="close">Close</button>
  </footer>
</dialog>
```

## Anti-patterns

- 自作のモーダルオーバーレイ（`position: fixed` + 背景を `inert` にするdiv等）で `<dialog>` を再実装する（禁止）
- `<div role="dialog">` に `aria-modal` を付けて自作する
- `showModal()` / `close()` を呼ぶJavaScriptを追加する（`command` / `commandfor` を使う）
- `::backdrop` クリックで閉じる動作を「ネイティブにある」と前提にした設計にする（ネイティブにはない。JSが必要）
- `command="show-modal"` を `commandfor` でない要素（`<a>` 等）に付与する。`commandfor` はボタン系要素で使う
- checkbox hack や hidden state でモーダルを再現する
