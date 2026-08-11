# Dashboard

## シナリオ

管理ダッシュボード (ナビ + メトリクスカード + フォーム + テーブル + アコーディオン + ページネーション + アカウントdropdown + 設定dialog) をHTML + nativum.cssだけで実装する。Nativumのreference implementationでもある。

## 必要component

- `navigation` — `nv-nav` / `nv-pagination` (+ `aria-current="page"`)
- `dropdown` — `nv-dropdown-trigger` / `nv-dropdown` / `nv-dropdown-end` (アカウントメニュー)
- `dialog` — 設定ダイアログ (`commandfor` / `command="show-modal"`)
- `table` — `nv-table-scroll` / `nv-table-striped`
- `details` — `nv-accordion`
- `button` — `nv-primary` / `nv-danger`
- `forms` — `nv-field`
- レイアウト: `nv-container` / `nv-grid` / `nv-stack-sm` / `nv-stack-lg` / `nv-cluster` / `nv-cluster-between`
- 内容: `nv-card` / `nv-badge` (各色variant) / `nv-text-muted` / `nv-notice` / `meter` / `hr`

## 構造の要点

```html
<header class="nv-container">
  <nav class="nv-nav nv-cluster-between" aria-label="Main">
    <span class="nv-cluster">
      <strong>Acme Admin</strong>
      <a href="/dashboard" aria-current="page">Dashboard</a>
      <a href="/projects">Projects</a>
    </span>

    <span style="--nv-anchor: --nv-anchor-account">
      <button class="nv-dropdown-trigger" popovertarget="account-menu" aria-haspopup="true">
        Hanako
      </button>
      <div id="account-menu" class="nv-dropdown nv-dropdown-end" popover>
        <div class="nv-stack-sm">
          <strong>Hanako Tanaka</strong>
          <span class="nv-text-muted">hanako@example.com</span>
          <button commandfor="settings" command="show-modal">Settings</button>
          <a href="/signout">Sign out</a>
        </div>
      </div>
    </span>
  </nav>
</header>

<main class="nv-container nv-stack-lg">
  <section class="nv-grid">
    <article class="nv-card nv-stack-sm">
      <span class="nv-text-muted">Projects</span>
      <strong>24</strong>
      <span class="nv-badge nv-badge-success">+3 this month</span>
    </article>
    <!-- メトリクスカードを nv-grid で並べる -->
  </section>

  <section class="nv-grid">
    <article class="nv-card">
      <h2>Team</h2>
      <div class="nv-table-scroll">
        <table class="nv-table-striped">
          <!-- th scope="col" / th scope="row"、状態は nv-badge -->
        </table>
      </div>
    </article>
  </section>

  <div class="nv-accordion">
    <details open><summary>Billing</summary><p>...</p></details>
    <details><summary>Security</summary><p>...</p></details>
  </div>

  <nav aria-label="Pagination">
    <ul class="nv-pagination">
      <!-- 現在ページは <span aria-current="page"> -->
    </ul>
  </nav>
</main>

<dialog id="settings">
  <header><h2>Settings</h2></header>
  <form action="/settings" method="post">
    <!-- nv-field で構成 -->
  </form>
  <footer>
    <button commandfor="settings" command="close">Cancel</button>
    <button class="nv-primary" type="submit" form="settings">Save changes</button>
  </footer>
</dialog>
```

要点:

- `nv-grid` は列数を指定せず、`--nv-grid-min` (デフォルト `16rem`) で自動調整。カード幅を変えたい場合のみインラインで `--nv-grid-min` を上書きする
- アカウントdropdownと設定dialogは `--nv-anchor` の親スコープと `commandfor` で宣言的に接続する
- テーマはサーバーが `<html data-theme="dark">` 等を出力して制御する。クライアント側theme switchはNativumの提供範囲外であり、ホストアプリケーションの責務として実装してよい
- ダミーリンク (`href="#"`) は例示のためのもので、実装ではサーバーが実URLを生成する

## Nativum外の実装境界

- メトリクス・テーブルデータ・ページネーションのページ数はサーバーが計算してレンダリング
- フォーム送信・ダイアログ内の保存は `method="post"` の通常送信
- ダッシュボードのリアルタイム更新 (WebSocket等) はNativumの対象外
