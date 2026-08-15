# Settings Page

## Purpose

`examples/settings.html` が本パターンの reference implementation である。

Admin / Settings 画面の構成パターン。ヘッダーの `nv-nav`、設定グループの `nv-accordion`、編集用の `<dialog>`、サーバー側 `data-theme` を組み合わせる。状態変更はすべてサーバー側の form submission で行い、再レンダリングされる。

## 構成要素

| 要素 | 使用する API / クラス |
|---|---|
| ヘッダーナビゲーション | `<nav class="nv-nav">` + `aria-current="page"`（現在ページのマーキングは状態の唯一の真実源、`src/60-components.css` の `a[aria-current="page"]` セレクタ） |
| ページ幅 | `<main class="nv-container-narrow">`（設定画面は狭幅 `--nv-narrow-width: 40rem` が基本） |
| 設定グループ | `.nv-accordion` + `<details>` / `<summary>`（ネイティブ開閉。`open` 属性で初期表示をサーバー側から指定） |
| フォーム | `.nv-field`（ラベル + コントロール + メッセージ）、ネイティブ検証（`required` / `type` / `minlength`） |
| 編集ダイアログ | `<button commandfor="..." command="show-modal">` + `<dialog>`（`header` / `footer` は要素セレクタで自動スタイル） |
| テーマ | `<html data-theme="dark">` / `<html data-theme="light">`（サーバー側で出力。Nativumはクライアント側 theme switch を提供しない。ホスト側JSでの実装はホストの責務として許可） |

## サーバー側 data-theme

Nativum のテーマはサーバーが決定する。デフォルトは `color-scheme: light dark`（OS 設定に追従）だが、サーバーが

```html
<html lang="en" data-theme="dark">
```

を出力すると `:root[data-theme="dark"]`（`src/20-tokens.css`）により `color-scheme: dark` に固定される。テーマ選択 UI がある場合も、通常の `<form method="post">` で送信し、サーバーが `data-theme` 付きの HTML を再出力する。

```html
<form action="/settings/theme" method="post">
  <div class="nv-field">
    <label for="theme">Theme</label>
    <select id="theme" name="theme">
      <option value="system" selected>System</option>
      <option value="light">Light</option>
      <option value="dark">Dark</option>
    </select>
  </div>
  <button class="nv-primary" type="submit">Save theme</button>
</form>
```

## 完成例

`nv-accordion` で設定グループを分け、破壊的操作の確認は `commandfor` + `<dialog>` + `method="post"` で行う。

```html
<!doctype html>
<html lang="en" data-theme="dark">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Account settings</title>
  <link rel="stylesheet" href="/vendor/nativum/nativum.css">
</head>
<body>
  <header class="nv-container">
    <nav class="nv-nav nv-cluster-between" aria-label="Main">
      <span class="nv-cluster" style="gap: var(--nv-space-2)">
        <strong>Acme</strong>
        <a href="/dashboard">Dashboard</a>
        <a href="/settings" aria-current="page">Settings</a>
      </span>
      <a href="/signout">Sign out</a>
    </nav>
  </header>

  <main class="nv-container-narrow nv-stack-lg" style="padding-block: 2rem 4rem">
    <section class="nv-stack-sm">
      <h1>Account settings</h1>
      <p class="nv-text-muted">
        変更はサーバーで検証され、このページに再レンダリングされます。
      </p>
    </section>

    <!-- プロフィール編集 (dialog) -->
    <section class="nv-card nv-cluster nv-cluster-between">
      <div class="nv-stack-sm">
        <strong>Hanako Tanaka</strong>
        <span class="nv-text-muted" style="font-size: var(--nv-font-size-sm)">
          hanako@example.com
        </span>
      </div>
      <button commandfor="profile-edit" command="show-modal">Edit profile</button>
    </section>

    <!-- 設定グループ (accordion) -->
    <div class="nv-accordion">
      <details open>
        <summary>Notifications</summary>
        <form action="/settings/notifications" method="post">
          <div class="nv-field">
            <label>Email notifications</label>
            <div class="nv-stack-sm">
              <label><input type="checkbox" name="digest" checked> Weekly digest</label>
              <label><input type="checkbox" name="alerts"> Security alerts</label>
            </div>
          </div>
          <div class="nv-cluster">
            <button class="nv-primary" type="submit">Save notifications</button>
          </div>
        </form>
      </details>

      <details>
        <summary>Security</summary>
        <form action="/settings/security" method="post">
          <div class="nv-field">
            <label for="s-password">New password</label>
            <input id="s-password" name="password" type="password"
                   minlength="8" autocomplete="new-password">
          </div>
          <div class="nv-cluster">
            <button class="nv-primary" type="submit">Update password</button>
          </div>
        </form>
      </details>
    </div>

    <!-- 危険操作 -->
    <section class="nv-cluster nv-cluster-between">
      <div class="nv-stack-sm">
        <strong>Danger zone</strong>
        <p class="nv-text-muted">アカウント削除は取り消せません。</p>
      </div>
      <button class="nv-danger" commandfor="delete-account" command="show-modal">
        Delete account
      </button>
    </section>
  </main>

  <!-- プロフィール編集ダイアログ -->
  <dialog id="profile-edit">
    <header>
      <h2>Edit profile</h2>
    </header>
    <form id="profile-form" action="/settings/profile" method="post">
      <div class="nv-field">
        <label for="pe-name">Display name</label>
        <input id="pe-name" name="name" type="text" value="Hanako Tanaka" required>
      </div>
      <div class="nv-field">
        <label for="pe-email">Email</label>
        <input id="pe-email" name="email" type="email" value="hanako@example.com" required>
      </div>
    </form>
    <footer>
      <button commandfor="profile-edit" command="close">Cancel</button>
      <button class="nv-primary" type="submit" form="profile-form">Save changes</button>
    </footer>
  </dialog>

  <!-- 削除確認ダイアログ -->
  <dialog id="delete-account">
    <header>
      <h2>Delete account?</h2>
    </header>
    <p>この操作は取り消せません。プロジェクトと全データが削除されます。</p>
    <footer>
      <button commandfor="delete-account" command="close">Cancel</button>
      <button class="nv-danger" type="submit" form="delete-form"
              name="action" value="delete">Delete</button>
    </footer>
  </dialog>
  <form id="delete-form" method="post" action="/settings/account" hidden></form>
</body>
</html>
```

## フォールバック

- `commandfor` 未対応環境では、`<dialog>` を `open` 属性付きでサーバーレンダリングし、操作対象をページ内フォームへ置き換える（`docs/components/dialog.md`）
- `details` / `summary` はネイティブ開閉なので、CSS が無くても設定グループの閲覧は可能
- `data-theme` はHTML属性であり、CSS が無くてもサーバー側のテーマ決定自体は機能する

## アンチパターン

- クライアント側 theme switch をNativumの提供機能として期待する（Nativumはサーバー側 `data-theme` のみを提供する。ホスト側JSでの実装はホストの責務）
- 設定グループを `<div>` + クリックハンドラで折りたたむ（`<details>` を使う）
- ダイアログの開閉に `showModal()` 等の JavaScript を書く（宣言的な `command` / `commandfor` で足りる。ホスト側JSの利用は禁止しないが、ネイティブprimitiveを不必要にJS stateへ置き換えない）
- 破壊的操作（削除等）を確認ダイアログなしで直接 `form` 送信する（確認は `<dialog>` + `method="post"` で行う）
- 存在しない Nativum クラス（`nv-panel` 等）を発明する。`src/*.css` に実在するクラスのみを使う
