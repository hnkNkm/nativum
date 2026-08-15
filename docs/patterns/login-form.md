# Login Form

## Purpose

`examples/login.html` が本パターンの reference implementation である。

ログインフォームのパターン。通常の `<form method="post" action="...">` によるサーバー送信、ネイティブ validation（`required` / `type="email"`）、サーバー側検証エラーの `aria-invalid` + `nv-field-error` による再レンダリング、`nv-container-narrow` による中央配置を組み合わせる。

ログインは状態変更であるため、JavaScript を使った AJAX 送信は行わない。ブラウザのネイティブ送信 → サーバーが成功時はリダイレクト、失敗時はエラー付きでフォームを再レンダリングする。

## 構成要素

| 要素 | 使用する API / クラス |
|---|---|
| 中央配置 | `<main class="nv-container-narrow">`（`--nv-narrow-width: 40rem` の狭幅コンテナ） |
| カード | `.nv-card`（ログインフォームを単一のサーフェスにまとめる） |
| フォーム | `<form method="post" action="/login">` + `autocomplete="email"` / `autocomplete="current-password"` |
| ネイティブ検証 | `required` / `type="email"` / `minlength`（送信時にブラウザがブロック） |
| クライアント側エラー表示 | `:user-invalid`（ユーザー操作後にのみ適用、`src/50-forms.css`） |
| サーバー側エラー表示 | `[aria-invalid="true"]` + `.nv-field-error` + `aria-describedby`（サーバー再レンダリング時に付与） |
| フォーム全体のエラー | `.nv-notice nv-notice-danger` + `role="status"` |

## サーバー側エラーの再レンダリング

サーバーは認証失敗時、エラー状態を焼き込んだ HTML を返す。Nativum のルールはこの HTML だけである。

- コントロールに `aria-invalid="true"` を付与 → 赤ボーダー（`src/50-forms.css` の `[aria-invalid="true"]` セレクタ）
- `.nv-field-error` にエラーメッセージを書き、`aria-describedby` でコントロールと関連付ける
- どのフィールドに紐づかないエラー（認証失敗全体など）は `.nv-notice nv-notice-danger` で表示する

```html
<div class="nv-field">
  <label for="email">Email</label>
  <input id="email" name="email" type="email" value="hanako@example.com" required
         aria-invalid="true" aria-describedby="email-error">
  <span class="nv-field-error" id="email-error">このメールアドレスは登録されていません。</span>
</div>
```

## 完成例

```html
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Sign in</title>
  <link rel="stylesheet" href="/vendor/nativum/nativum.css">
</head>
<body>
  <main class="nv-container-narrow" style="padding-block: 4rem">
    <section class="nv-card nv-stack">
      <header class="nv-stack-sm">
        <h1 style="margin-block-end: 0">Sign in</h1>
        <p class="nv-text-muted">Acme Admin</p>
      </header>

      <!-- サーバーが認証失敗時に再レンダリングするフォーム全体のエラー -->
      <div class="nv-notice nv-notice-danger" role="status">
        メールアドレスまたはパスワードが正しくありません。
      </div>

      <form action="/login" method="post">
        <div class="nv-field">
          <label for="email">Email</label>
          <input id="email" name="email" type="email" autocomplete="email" required
                 aria-invalid="true" aria-describedby="email-error">
          <span class="nv-field-error" id="email-error">
            このメールアドレスは登録されていません。
          </span>
        </div>

        <div class="nv-field">
          <label for="password">Password</label>
          <input id="password" name="password" type="password"
                 autocomplete="current-password" minlength="8" required>
        </div>

        <div class="nv-field nv-cluster nv-cluster-between">
          <label><input type="checkbox" name="remember"> Remember me</label>
          <a href="/forgot-password">Forgot password?</a>
        </div>

        <button class="nv-primary" type="submit" style="width: 100%">Sign in</button>
      </form>

      <p class="nv-text-muted" style="font-size: var(--nv-font-size-sm)">
        未入力・形式エラーは送信前にブラウザのネイティブ検証がブロックします。
      </p>
    </section>
  </main>
</body>
</html>
```

## バリデーションの分担

| レイヤー | 役割 |
|---|---|
| ブラウザ（ネイティブ） | `required` / `type="email"` / `minlength` による送信前チェック。`novalidate` で無効化しない |
| サーバー | 認証と業務ルール（登録済みメールアドレス等）の検証。失敗時は `aria-invalid` + `nv-field-error` 付きで再レンダリング |
| CSS | `:user-invalid`（クライアント操作後）と `[aria-invalid="true"]`（サーバー検証済み）の両方を赤ボーダーで表現（`src/50-forms.css`） |

## フォールバック

- CSS が無くてもフォームは通常送信される（すべて標準HTML）
- ネイティブ検証非対応環境でも `required` / `type` はHTML属性として存在し、サーバー側で再検証する
- `nv-container-narrow` は `width: min(100%, ...)` なので、CSS 非対応時は画面幅いっぱいに表示される

## アンチパターン

- JavaScript で独自バリデーションを実装し `novalidate` を付ける（ネイティブ検証を使う）
- `fetch()` / XMLHttpRequest によるログイン送信と、エラーの JSON 返却（通常の form submission を使う）
- `placeholder` をラベル代わりにする（`<label>` を使う）
- パスワードフィールドに `maxlength` をむやみに付ける（サーバー側のパスワードポリシーに任せる）
- エラーを色のみ（赤ボーダー）で伝える（`.nv-field-error` のテキストと `.nv-notice-danger` を必ず併用する）
- ログインフォームのエラー表示に `<div role="alert">` を使う（`role="status"` 付き `.nv-notice` を使う）
