# Dialog

## Purpose

ネイティブの `<dialog>` 要素でモーダルダイアログを実現する。開閉はHTML Standardの `command` / `commandfor` 属性で宣言的に行う。カスタムモーダル実装は禁止。

## Native primitive

- `<dialog>` / `<dialog open>`
- `commandfor` + `command="show-modal"` / `command="close"` / `command="request-close"`
- `<form method="dialog">`（submitでdialogを閉じ、値を `close(returnValue)` へ渡す。値の読み取りにはJavaScriptが必要）
- `::backdrop`
- `cancel` / `close` イベント（Esc操作等、ブラウザ内部動作）

**注意**: `command="show"` / `command="hide"` はdialogには定義されていない（popover用のコマンド）。dialogに対して使用してはならない。

**注意**: 非モーダルのオーバーレイには `<dialog>` ではなく **Popover API** が適切なprimitiveである（`docs/components/popover.md` 参照）。

## Required markup

`commandfor` でトリガーとダイアログを結び、`command="show-modal"` でモーダル表示、`command="close"` で閉じる。

```html
<button commandfor="settings" command="show-modal">Open settings</button>

<dialog id="settings">
  <header>
    <h2>Settings</h2>
  </header>

  <form action="/settings" method="post" id="settings-form">
    <div class="nv-field">
      <label for="d-name">Display name</label>
      <input id="d-name" name="name" type="text" required>
    </div>
  </form>

  <footer>
    <button commandfor="settings" command="close">Close</button>
    <button class="nv-primary" type="submit" form="settings-form">Save</button>
  </footer>
</dialog>
```

要点:

- フッターのsubmitボタンは `form="<フォームのid>"` でフォームと結びつける。`form` 属性が参照するのは **`<form>` 要素のid** であり、`<dialog>` のidではない
- `header` / `footer` は `src/60-components.css` の要素セレクタでスタイルされる。`dialog` 自体に専用クラスは存在しない

## Optional classes

`dialog` 固有のNativumクラスは存在しない（`dialog` / `header` / `footer` / `::backdrop` は要素セレクタで自動スタイル）。内部レイアウトには以下を併用できる。

- `nv-field` — ダイアログ内フォームのフィールドグループ
- `nv-primary` / `nv-danger` — フッターの主要アクション / 破壊的操作ボタン
- `nv-cluster` / `nv-stack-sm` — レイアウト補助
- `nv-container-narrow` — ページ全体の幅制限

## Supported interactions

すべてブラウザのネイティブ動作である。

- `commandfor` + `command="show-modal"` でモーダル表示（トップレイヤー + 背景の `inert` 化 + フォーカストラップ）
- `command="close"` で閉じる
- `command="request-close"` で `cancel` イベントを経由して閉じる（JavaScriptの `cancel` ハンドラで中止可能。ハンドラが無ければ `close` と同等）
- Escキーでキャンセル（`cancel` イベント）
- `<form method="dialog">` の submit でダイアログを閉じ、フォーム値を `close(returnValue)` へ渡す
- `dialog[open]` でサーバーレンダリングされた初期表示
- `::backdrop` クリックでの自動破棄はネイティブの `<dialog>` には**存在しない**。その動作にはJavaScriptが必要であり、Nativumは提供しない（`closedby="any"` 属性はprogressive enhancementとして利用可能）

## `method="dialog"` の正しい使い方

`<form method="dialog">` は**サーバーへ送信しない**。ダイアログを閉じてフォーム値を `returnValue` に渡すだけであり、値の読み取りにはJavaScriptが必要になる。

そのため:

- 状態変更（削除・保存等）には `<form method="dialog">` を使わず、通常の `<form method="post" action="...">` をサーバーへの送信に使う（`docs/patterns/server-actions.md` 参照）
- `<form method="dialog">` は「閉じる際に値を渡す」用途（例: 選択結果を返すピッカー）に限る
- フォームはダイアログの**子孫**に置く（`method="dialog"` は直近のdialog祖先を閉じるため、ダイアログ外のフォームでは動作しない）

```html
<dialog id="picker">
  <header><h2>Pick a plan</h2></header>
  <form method="dialog">
    <div class="nv-stack-sm">
      <label><input type="radio" name="plan" value="pro" checked> Pro</label>
      <label><input type="radio" name="plan" value="team"> Team</label>
    </div>
    <button class="nv-primary" type="submit">OK</button>
  </form>
</dialog>
<!-- returnValue の読み取り (host JavaScript) -->
```

## Accessibility

- `show-modal` はモーダル性（背景 `inert`、フォーカストラップ、Escキャンセル）をブラウザが保証する
- ダイアログにアクセシブルネームを与えるため、`header` 内に `<h2>` 等の見出しを置く
- 見出しを付けたくない場合は `aria-labelledby` を使用する（ネイティブ要素なので `role="dialog"` は不要）
- 背景が `inert` になるため、ダイアログ外のフォーカス移動は構造的に不可能。独自のfocus trapは実装しない
- モーダルの開閉状態はスクリーンリーダーに通知される。`aria-modal` 等の手動付与は不要

## Progressive enhancements

- `command` / `commandfor` による宣言的開閉（HTML Standard定義）。未対応環境では動作しないため、下記フォールバックが必要
- `closedby="any"` / `closedby="closerequest"`（対応環境のみ）によるlight dismiss
- 表示 / 非表示のフェードとスケールは `src/70-motion.css` の `@starting-style` + `allow-discrete` transition（`prefers-reduced-motion: no-preference` 時のみ）
- `::backdrop` の半透明背景とフェード

## Fallback behavior

`commandfor` 未対応環境では、`examples/dialog.html` の推奨パターンに従う。

1. `<dialog>` を `open` 属性付きでサーバーレンダリングする（初期表示を保証）
2. 操作対象を `commandfor` の代わりにページ内の通常フォームへ置き換える

```html
<!-- 未対応環境向け: サーバー側で open を付けてレンダリングする -->
<dialog id="settings" open>
  <header>
    <h2>Settings</h2>
  </header>
  <form action="/settings" method="post" id="settings-form">
    ...
  </form>
  <footer>
    <button type="submit" form="settings-form">Save</button>
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
  <form action="/settings" method="post" id="settings-form">
    <div class="nv-field">
      <label for="s-name">Display name</label>
      <input id="s-name" name="name" type="text" value="Hanako" required>
    </div>
  </form>
  <footer>
    <button commandfor="settings" command="close">Cancel</button>
    <button class="nv-primary" type="submit" form="settings-form">Save changes</button>
  </footer>
</dialog>
```

確認ダイアログ（サーバーへのPOST送信）:

```html
<button commandfor="confirm" command="show-modal">Request confirmation</button>

<dialog id="confirm">
  <header>
    <h2>Delete project?</h2>
  </header>
  <p>この操作は取り消せません。</p>
  <footer>
    <button commandfor="confirm" command="close">Cancel</button>
    <button class="nv-danger" type="submit" form="delete-form" name="action" value="delete">Delete</button>
  </footer>
</dialog>
<form method="post" action="/projects/delete" id="delete-form" hidden></form>
```

## Anti-patterns

- 自作のモーダルオーバーレイ（`position: fixed` + 背景を `inert` にするdiv等）で `<dialog>` を再実装する（禁止）
- `<div role="dialog">` に `aria-modal` を付けて自作する
- `showModal()` / `close()` を呼ぶJavaScriptを追加する（`command` / `commandfor` を使う）
- `command="show"` / `command="hide"` をdialogに使う（dialogに定義されていないコマンド。popover用）
- `<form method="dialog">` をダイアログの外に置く（直近のdialog祖先が無く送信が破棄される）
- `method="dialog"` のフォームで「サーバーに送信される」と誤解する（送信されない。状態変更は `method="post"` を使う）
- `form="..."` 属性で `<dialog>` や `<div>` のidを参照する（参照できるのは `<form>` のidのみ）
- `::backdrop` クリックで閉じる動作を「ネイティブにある」と前提にした設計にする（ネイティブにはない。JSが必要か `closedby` 属性を使う）
- `commandfor` をボタン系でない要素（`<a>` 等）に付与する
- checkbox hack や hidden state でモーダルを再現する
