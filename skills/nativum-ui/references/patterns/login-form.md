# Login Form

## シナリオ

メールアドレス + パスワードのログインフォームを、ネイティブ検証 + サーバー側認証で実装する。

## 必要component

- `forms` — `nv-field` / `nv-field-error`, `fieldset` (任意)
- `button` — `nv-primary` (送信)
- レイアウト: `nv-container-narrow` / `nv-stack-lg` / `nv-cluster`

## 構造の要点

```html
<main class="nv-container-narrow">
  <section class="nv-stack-lg" style="padding-block: 3rem">
    <header class="nv-stack-sm">
      <h1>Sign in</h1>
      <p class="nv-text-muted">アカウントにログインしてください。</p>
    </header>

    <form action="/login" method="post" class="nv-stack-sm">
      <div class="nv-field">
        <label for="email">Email</label>
        <input id="email" name="email" type="email" autocomplete="email" required>
      </div>

      <div class="nv-field">
        <label for="password">Password</label>
        <input id="password" name="password" type="password"
               autocomplete="current-password" minlength="8" required>
      </div>

      <div class="nv-field">
        <label><input type="checkbox" name="remember" value="1"> この端末で保持する</label>
      </div>

      <div class="nv-cluster">
        <button class="nv-primary" type="submit">Sign in</button>
      </div>
    </form>

    <p class="nv-text-muted">アカウントをお持ちでない方は <a href="/signup">登録</a> してください。</p>
  </section>
</main>
```

要点:

- `autocomplete` 属性 (`email` / `current-password`) は必須に近い。パスワードマネージャが機能する
- クライアント検証はネイティブ属性 (`type="email"` / `required` / `minlength`) のみ。パスワードの複雑性ルールはサーバー側で検証する
- 認証エラー (メールアドレスまたはパスワードが違う等) はサーバーがページを再レンダリングし、`nv-field-error` または `nv-notice nv-notice-danger` で伝える
- `hidden` なCSRFトークンはサーバーが `<input type="hidden">` として埋め込む

## Nativum外の実装境界

- セッション管理・パスワード検証・CSRF対策はサーバー側の責務
- エラーメッセージの文言はサーバーが生成する
- ログイン後のリダイレクトもサーバーの `Location` 等による通常遷移

## 補足

- フォーム全体は必ず `<form method="post" action="/login">` で送る。AJAX/fetchラッパーは使わない
- 認証失敗時の再表示では、`aria-invalid="true"` を付けた入力と `nv-field-error` を対応付ける (patterns/settings-page の例と同じ流儀)
