# Settings Page

## シナリオ

設定ページ (プロフィール、通知、請求等のセクションを持つ) を、フォーム送信 + サーバーレンダリングで実装する。

## 必要component

- `forms` — `nv-field` / `nv-field-hint` / `nv-field-error`
- `button` — `nv-primary` (保存), `nv-danger` (削除等)
- `details` — `nv-accordion` (セクションの折りたたみ)
- `dialog` — 破壊的操作の確認 (キャンセルのみ `method="dialog"`、実行は隠し `method="post"` フォーム + ボタンの `form` 属性)
- レイアウト: `nv-container-narrow` / `nv-stack-lg` / `nv-cluster`

## 構造の要点

```html
<main class="nv-container-narrow nv-stack-lg">
  <section class="nv-stack-sm">
    <h1>Settings</h1>
    <p class="nv-text-muted">プロフィール設定</p>
  </section>

  <div class="nv-accordion">
    <details open>
      <summary>Profile</summary>
      <form action="/settings/profile" method="post">
        <div class="nv-field">
          <label for="name">Name</label>
          <input id="name" name="name" type="text" required>
        </div>
        <div class="nv-cluster">
          <button class="nv-primary" type="submit">Save</button>
        </div>
      </form>
    </details>
    <details>
      <summary>Notifications</summary>
      <form action="/settings/notifications" method="post">
        <div class="nv-stack-sm">
          <label><input type="checkbox" name="digest" checked> Email digest</label>
          <label><input type="checkbox" name="weekly"> Weekly report</label>
        </div>
        <div class="nv-cluster">
          <button class="nv-primary" type="submit">Save</button>
        </div>
      </form>
    </details>
  </div>
</main>
```

要点:

- 各セクションを独立した `<form method="post">` にする (1フォームで全部送るより失敗範囲が狭い)
- サーバー側検証エラーは `aria-invalid="true"` + `nv-field-error` で再レンダリング
- 保存結果のフィードバックは `nv-notice` (popoverはlight dismissで閉じるため不可)
- 破壊的操作は `<dialog>` で確認し、実行は隠し `<form method="post">` + ボタンの `form` 属性でサーバーへPOST (`method="dialog"` はダイアログを閉じる用途のみ。`server-actions.md` 参照)

## Nativum外の実装境界

- フォームの受け取り・検証・保存はサーバー側 (`method="post"` の通常送信)
- `open` 属性 / `aria-current` / `value` 等の初期状態はすべてサーバーレンダリング
- クライアント状態 (入力中の中間保存等) はNativumでは実装しない
