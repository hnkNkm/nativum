# Dialog

## 目的

ネイティブの `<dialog>` でモーダルダイアログを実現する。Core は `<dialog>` / `<dialog open>`。対応環境では `command` / `commandfor` で宣言的に開閉する (Enhancement)。カスタムモーダル実装は禁止。

**注意**: 非モーダルのオーバーレイには `<dialog>` ではなく **Popover API** が適切なprimitiveである (`popover.md` 参照)。

## ネイティブprimitive

- `<dialog>` / `<dialog open>`
- `commandfor` + `command="show-modal"` / `command="close"` / `command="request-close"` (Enhancement)
- `<form method="dialog">` (submitで閉じ、**submitterボタンの `value`** を `close(returnValue)` へ渡す。読み取りにはJavaScriptが必要)
- `::backdrop` / Escキー (`cancel` イベント)

**注意**: `command="show"` / `command="hide"` は標準の `command` keyword ではない (popover用の標準commandは `show-popover` / `hide-popover` / `toggle-popover`)。dialogに対して使用してはならない。

## Required markup

```html
<button commandfor="settings" command="show-modal">Open settings</button>

<dialog id="settings">
  <header>
    <h2>Settings</h2>
  </header>
  <form action="/settings" method="post" id="settings-form">
    ...
  </form>
  <footer>
    <button commandfor="settings" command="close">Close</button>
    <button class="nv-primary" type="submit" form="settings-form">Save</button>
  </footer>
</dialog>
```

要点:

- `form="..."` が参照するのは **`<form>` 要素のid** であり、`<dialog>` のidではない
- `header` / `footer` / `::backdrop` は要素セレクタで自動スタイルされる

## Nativum classes

`dialog` 固有のクラスは存在しない (要素セレクタで自動スタイル)。内部レイアウトに以下を併用できる:

- `nv-field` — ダイアログ内フォームのフィールドグループ
- `nv-primary` / `nv-danger` — フッターの主要 / 破壊的操作ボタン

## 動作 (ネイティブのinteraction)

- `command="show-modal"` でモーダル表示 (トップレイヤー + 背景inert + フォーカストラップ)
- `command="close"` で閉じる。Escでキャンセル
- `command="request-close"` で `cancel` イベント経由で閉じる (ハンドラが無ければ `close` と同等)
- `<form method="dialog">` のsubmitで閉じ、submitterボタンの `value` を `close(returnValue)` へ渡す (**サーバーへは送信されない**)
- `dialog[open]` でサーバーレンダリング初期表示
- **デフォルトの `<dialog>` は backdrop クリックだけでは閉じない**。対応環境では `closedby="any"` でネイティブの light dismiss を opt-in できる (Enhancement)

## `method="dialog"` の使い分け

- 状態変更 (削除・保存) には使わない。通常の `<form method="post" action="...">` を使う
- **submitterボタンの `value`** で結果を伝える用途に限る (例: 選択肢を返すボタン列)。フォームの入力値が `returnValue` に自動で入るわけではない
- フォームはダイアログの**子孫**に置く (`method="dialog"` は直近のdialog祖先を閉じる)

## フォールバック

`commandfor` 未対応環境では (Core 経路):

1. `<dialog>` を `open` 属性付きでサーバーレンダリング (初期表示を保証)
2. 操作対象をページ内の通常フォーム (`<form method="post">`) へ置き換える。`examples/dialog.html` のフォールバック節に実マークアップがある

高度なCSS (transition / `@starting-style`) がなくても表示・操作・意味は維持される。

## Anti-patterns

- `position: fixed` + 自作オーバーレイでモーダルを再実装
- `showModal()` / `close()` を呼ぶJSを追加
- `command="show"` / `command="hide"` をdialogに使う (標準の `command` keyword ではない)
- `method="dialog"` のフォームをダイアログ外に置く (送信が破棄される)
- `form="..."` で `<dialog>` / `<div>` のidを参照する (`<form>` のidのみ有効)
- `::backdrop` クリックで閉じることを「ネイティブにある」と前提にする (デフォルトでは閉じない。`closedby="any"` で opt-in)
- checkbox hack でモーダルを再現

## 詳細

この Skill 内の該当 section が正本。リポジトリの `docs/components/` は人間向けの詳細版。
