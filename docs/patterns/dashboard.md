# Dashboard

## Purpose

管理ダッシュボードのパターン。`nv-container` / `nv-nav` によるページ骨格、`nv-grid` の統計カード、`table`、`nv-pagination`、アカウント popover（`nv-dropdown-trigger` / `nv-dropdown` / `--nv-anchor`）を組み合わせる。

**`examples/dashboard.html` が Nativum v0.1 の reference implementation である**。完全な実装はそちらを参照し、本パターンはその構成の解説と要点の抜粋を提供する。

## 構成要素

| 要素 | 使用する API / クラス |
|---|---|
| ページ骨格 | `<header class="nv-container">`（nav）+ `<main class="nv-container nv-stack-lg">` |
| ヘッダーナビ | `<nav class="nv-nav nv-cluster-between">` + `aria-current="page"` |
| アカウント popover | `style="--nv-anchor: --nv-anchor-account"` のスコープ内に `nv-dropdown-trigger`（`popovertarget` 付き）+ `nv-dropdown nv-dropdown-end`（`popover` 付き） |
| 統計カード | `<section class="nv-grid">` + `.nv-card nv-stack-sm`（指標の数字は `<strong>`、変化は `nv-badge-*`、ストレージ等は `<meter>`） |
| テーブル | `.nv-table-scroll`（横スクロールラッパー）+ `table` / `thead` / `th scope="col"` / `td` |
| ページネーション | `<nav aria-label="Pagination">` + `<ul class="nv-pagination">`（現在ページは `<span aria-current="page">`） |
| 設定ダイアログ | `commandfor` + `<dialog>`（`header` / `form` / `footer` 構成） |

## アカウント popover

トリガーとdropdownを同じ `--nv-anchor` スコープに置く。アンカー非対応環境では popover のデフォルト配置にフォールバックする（`docs/components/dropdown.md`）。

```html
<span style="--nv-anchor: --nv-anchor-account">
  <button class="nv-dropdown-trigger" popovertarget="account-menu">
    Hanako
  </button>

  <div id="account-menu" class="nv-dropdown nv-dropdown-end" popover>
    <div class="nv-stack-sm">
      <strong>Hanako Tanaka</strong>
      <span class="nv-text-muted" style="font-size: var(--nv-font-size-xs)">hanako@example.com</span>
      <button commandfor="settings" command="show-modal">Settings</button>
      <a href="/signout">Sign out</a>
    </div>
  </div>
</span>
```

`--nv-anchor` の値はページ内で一意にする（`--nv-anchor-*` の形式）。このpopupは通常のリンク / ボタンの集合でありARIA menu widgetではないため、`role="menu"` / `aria-haspopup="true"` は付けない。`popovertarget` のネイティブinvoker relationshipがexpanded stateを支援技術へ公開する。

## 統計カード（`nv-grid`）

`nv-grid` は列数の代わりに最小列幅 `--nv-grid-min`（既定 `16rem`）を管理する。列数を増やしたいセクションは `style="--nv-grid-min: 22rem"` のようにトークンを上書きする（`src/40-layout.css`）。

```html
<section class="nv-grid" aria-label="Metrics">
  <article class="nv-card nv-stack-sm">
    <span class="nv-text-muted" style="font-size: var(--nv-font-size-sm)">Projects</span>
    <strong style="font-size: var(--nv-font-size-3xl)">24</strong>
    <span class="nv-badge nv-badge-success">+3 this month</span>
  </article>
  <article class="nv-card nv-stack-sm">
    <span class="nv-text-muted" style="font-size: var(--nv-font-size-sm)">Storage</span>
    <strong style="font-size: var(--nv-font-size-3xl)">82%</strong>
    <meter min="0" max="100" value="82" low="70" high="90">82%</meter>
  </article>
</section>
```

## 完成例

`examples/dashboard.html` の要旨（構成は同ファイルが正。冒頭のテーマコメントも確認すること）:

```html
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Admin Dashboard</title>
  <link rel="stylesheet" href="/vendor/nativum/nativum.css">
</head>
<body>
  <header class="nv-container" style="padding-block: 1rem">
    <nav class="nv-nav nv-cluster-between" aria-label="Main">
      <span class="nv-cluster" style="gap: var(--nv-space-2)">
        <strong>Acme Admin</strong>
        <a href="/dashboard" aria-current="page">Dashboard</a>
        <a href="/projects">Projects</a>
        <a href="/settings">Settings</a>
      </span>

      <span style="--nv-anchor: --nv-anchor-account">
        <button class="nv-dropdown-trigger" popovertarget="account-menu">
          Hanako
        </button>

        <div id="account-menu" class="nv-dropdown nv-dropdown-end" popover>
          <div class="nv-stack-sm">
            <strong>Hanako Tanaka</strong>
            <span class="nv-text-muted" style="font-size: var(--nv-font-size-xs)">
              hanako@example.com
            </span>
            <button commandfor="settings" command="show-modal">Settings</button>
            <a href="/signout">Sign out</a>
          </div>
        </div>
      </span>
    </nav>
  </header>

  <main class="nv-container nv-stack-lg" style="padding-block: 1rem 4rem">
    <section class="nv-cluster nv-cluster-between">
      <div class="nv-stack-sm">
        <h1 style="margin-block-end: 0">Dashboard</h1>
        <p class="nv-text-muted">Overview of your workspace</p>
      </div>
      <div class="nv-cluster">
        <button commandfor="settings" command="show-modal">Settings</button>
        <button class="nv-primary" commandfor="settings" command="show-modal">
          New project
        </button>
      </div>
    </section>

    <!-- 統計カード -->
    <section class="nv-grid" aria-label="Metrics">
      <article class="nv-card nv-stack-sm">
        <span class="nv-text-muted" style="font-size: var(--nv-font-size-sm)">Projects</span>
        <strong style="font-size: var(--nv-font-size-3xl)">24</strong>
        <span class="nv-badge nv-badge-success">+3 this month</span>
      </article>
      <article class="nv-card nv-stack-sm">
        <span class="nv-text-muted" style="font-size: var(--nv-font-size-sm)">Active members</span>
        <strong style="font-size: var(--nv-font-size-3xl)">18</strong>
        <span class="nv-badge nv-badge-primary">2 pending</span>
      </article>
      <article class="nv-card nv-stack-sm">
        <span class="nv-text-muted" style="font-size: var(--nv-font-size-sm)">Storage</span>
        <strong style="font-size: var(--nv-font-size-3xl)">82%</strong>
        <meter min="0" max="100" value="82" low="70" high="90">82%</meter>
      </article>
    </section>

    <!-- チームテーブル -->
    <section class="nv-card">
      <div class="nv-cluster-between nv-cluster">
        <h2 style="font-size: var(--nv-font-size-xl)">Team</h2>
        <span class="nv-badge">4 members</span>
      </div>
      <div class="nv-table-scroll">
        <table>
          <thead>
            <tr>
              <th scope="col">Member</th>
              <th scope="col">Role</th>
              <th scope="col">Status</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <th scope="row">Hanako Tanaka</th>
              <td>Owner</td>
              <td><span class="nv-badge nv-badge-success">Active</span></td>
            </tr>
            <tr>
              <th scope="row">Taro Yamada</th>
              <td>Developer</td>
              <td><span class="nv-badge nv-badge-warning">Invited</span></td>
            </tr>
            <tr>
              <th scope="row">Kenji Ito</th>
              <td>Developer</td>
              <td><span class="nv-badge nv-badge-danger">Suspended</span></td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>

    <!-- ページネーション -->
    <nav aria-label="Project history">
      <ul class="nv-pagination">
        <li><a href="/projects?page=1">Prev</a></li>
        <li><a href="/projects?page=1">1</a></li>
        <li><span aria-current="page">2</span></li>
        <li><a href="/projects?page=3">3</a></li>
        <li><a href="/projects?page=3">Next</a></li>
      </ul>
    </nav>
  </main>

  <!-- 設定ダイアログ -->
  <dialog id="settings">
    <header>
      <h2>Settings</h2>
    </header>
    <form id="settings-form" action="/settings" method="post">
      <div class="nv-field">
        <label for="s-name">Display name</label>
        <input id="s-name" name="name" type="text" value="Hanako Tanaka" required>
      </div>
      <div class="nv-field">
        <label for="s-email">Email</label>
        <input id="s-email" name="email" type="email" value="hanako@example.com" required>
      </div>
    </form>
    <footer>
      <button commandfor="settings" command="close">Cancel</button>
      <button class="nv-primary" type="submit" form="settings-form">Save changes</button>
    </footer>
  </dialog>
</body>
</html>
```

## フォールバック

- **アンカー非対応環境**（Anchor Positioning なし）: `@supports` ガードにより絶対配置が無効になり、popover のデフォルト配置にフォールバックする。開閉とリンク操作は維持される
- **popover 非対応環境**: `[popover]` 要素はドキュメントフロー内の通常コンテンツとして表示される。アカウントメニューがフロー内に見えても意味が通るよう、リンクリストとして設計する
- `commandfor` 未対応環境: `<dialog>` を `open` 属性付きでサーバーレンダリングする（`docs/components/dialog.md`）
- `nv-grid` は `minmax` + `auto-fit` により、横幅が狭い環境では自動的に1列に折りたたまれる

## アンチパターン

- 統計カードの変化量を色（`nv-badge-success` 等）だけに頼って伝える。バッジはテキスト付きで使用する
- ページネーションの現在ページを `<a>` にする（`<span aria-current="page">` を使う、`docs/components/navigation.md`）
- 通常リンクリストpopupへ `role="menu"` / `aria-haspopup="true"` を付ける（`docs/components/dropdown.md`）
- ネイティブ `popovertarget` のexpanded stateを独自 `aria-expanded` で手動同期する
- ダッシュボードの状態更新（新規プロジェクト作成等）を fetch / WebSocket で行う（form submission を使う、`docs/patterns/server-actions.md`）
- 存在しない Nativum クラス（`nv-stat` 等）を発明する。`src/*.css` に実在するクラスのみを使う
