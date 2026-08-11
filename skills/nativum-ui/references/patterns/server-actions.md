# Server Actions

## シナリオ

状態変更 (フォーム送信、削除、設定保存) を、クライアントJavaScriptなしでサーバーへの通常送信にマップする。Nativumはサーバー側アーキテクチャを限定せず、最終的に生成されるHTMLだけを要求する。

## 必要component

- `forms` — 送信フォーム (`method="post"`) と検証状態
- `button` — `nv-primary` / `nv-danger` の送信・破壊的操作ボタン
- `dialog` — 破壊的操作の確認
- 内容: `nv-notice` (送信結果のフィードバック)

## 構造の要点

状態変更は `<form method="post" action="...">` の通常送信を第一候補とする。

```html
<form action="/projects" method="post">
  <div class="nv-field">
    <label for="name">Project name</label>
    <input id="name" name="name" type="text" required>
  </div>
  <div class="nv-cluster">
    <button class="nv-primary" type="submit">Create project</button>
  </div>
</form>
```

破壊的操作は `<dialog>` で確認し、実行はサーバーへの通常POSTで行う。

```html
<button commandfor="confirm" command="show-modal">Delete project</button>

<dialog id="confirm">
  <header><h2>Delete project?</h2></header>
  <p>この操作は取り消せません。</p>
  <footer>
    <button commandfor="confirm" command="close">Cancel</button>
    <button class="nv-danger" type="submit" form="delete-form"
            name="action" value="delete">Delete</button>
  </footer>
</dialog>
<form method="post" action="/projects/123/delete" id="delete-form" hidden></form>
```

状態変更はサーバーへの通常POST (`action="/projects/123/delete"` 等) で実行する。
`<form method="dialog">` はサーバー送信をしないため、状態変更には使わない (値の受け渡し用途のみ。`dialog.md` 参照)。

サーバー側検証エラーの再レンダリング:

```html
<div class="nv-field">
  <label for="email">Email</label>
  <input id="email" name="email" type="email" value="..."
         aria-invalid="true" aria-describedby="email-error" required>
  <span class="nv-field-error" id="email-error">このメールアドレスは既に登録されています。</span>
</div>
```

## Nativum外の実装境界

- サーバー側: バリデーション (必須・形式・重複等)、認証・認可、セッション、CSRF対策、DB書き込み
- クライアント側はHTMLのみ。fetch / htmx / Turbo 等のクライアントスクリプトはNativum component実装の依存として**追加しない**
- リダイレクトはサーバーの `Location` 等による通常遷移
- 非同期 (POST後に部分更新する) などの挙動はNativumの対象外。必要ならページ全体の再レンダリングで実現する

## 補足

- フォームの `action` / `method` はサーバーが生成する実URLを使う
- クライアント検証はネイティブ属性のみ (`:user-invalid`)。サーバー検証との二重化は `aria-invalid` で表現する
