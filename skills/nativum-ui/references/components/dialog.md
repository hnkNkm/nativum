# Dialog

## 目的

ネイティブの `<dialog>` でモーダル / ノンモーダルのダイアログを実現する。開閉はHTML Standardの `command` / `commandfor` 属性で宣言的に行う。カスタムモーダル実装は禁止。

## ネイティブprimitive

- `<dialog>` / `<dialog open>`
- `commandfor` + `command="show-modal"` / `command="show"` / `command="close"` / `command="hide"`
- `<form method="dialog">` (submitで閉じ、値を `close()` へ渡す)
- `::backdrop` / Escキー (`cancel` イベント)

## Required markup

```html
<button commandfor="settings" command="show-modal">Open settings</button>

<dialog id="settings">
  <header>
    <h2>Settings</h2>
  </header>
  <p>本文。</p>
  <footer>
    <button commandfor="settings" command="close">Close</button>
  </footer>
</dialog>
```

`header` / `footer` / `::backdrop` は要素セレクタで自動スタイルされる。

## Nativum classes

`dialog` 固有のクラスは存在しない (要素セレクタで自動スタイル)。内部レイアウトに以下を併用できる:

- `nv-field` — ダイアログ内フォームのフィールドグループ
- `nv-primary` / `nv-danger` — フッターの主要 / 破壊的操作ボタン

## 動作 (ネイティブのinteraction)

- `command="show-modal"` でモーダル表示 (トップレイヤー + 背景inert + フォーカストラップ)
- `command="show"` / `command="hide"` でノンモーダル表示 / 非表示
- `command="close"` で閉じる。Escでキャンセル
- `<form method="dialog">` のsubmitで閉じ、値を `close(returnValue)` へ渡す
- `dialog[open]` でサーバーレンダリング初期表示
- **`::backdrop` クリックで閉じる動作はネイティブに存在しない** (JSが必要)

## フォールバック

`commandfor` 未対応環境では:

1. `<dialog>` を `open` 属性付きでサーバーレンダリング (初期表示を保証)
2. 操作対象をページ内の通常フォーム (`<form method="post">`) へ置き換える

高度なCSS (transition / `@starting-style`) がなくても表示・操作・意味は維持される。

## Anti-patterns

- `position: fixed` + 自作オーバーレイでモーダルを再実装
- `showModal()` / `close()` を呼ぶJSを追加
- `::backdrop` クリックで閉じることを「ネイティブにある」と前提にする
- checkbox hack でモーダルを再現

## 詳細

詳細は `../../../../docs/components/dialog.md` を参照。
