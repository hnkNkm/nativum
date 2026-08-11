# Dropdown

## Purpose

Popover API + CSS Anchor Positioning で、トリガーに紐付いたアンカー配置のメニューを実現する。シンプルなリンクリスト（またはボタンリスト）をpopoverとして表示し、アンカー非対応環境ではpopoverのデフォルト配置にフォールバックする。

## Native primitive

- `[popover]` + `popovertarget`（Popover API）
- CSS Anchor Positioning: `anchor-name` / `position-anchor` / `anchor(...)`
- `--nv-anchor` カスタムプロパティ（一意なアンカー名を指定するNativum規約）
- `@supports (anchor-name: ...) and (top: anchor(top))` による機能検出（`src/60-components.css`）

## Required markup

トリガーとメニューを同じスコープ（アンカー名を共有する親要素）に置く。

```html
<div style="--nv-anchor: --nv-anchor-actions">
  <button class="nv-dropdown-trigger" popovertarget="actions">
    Actions <span aria-hidden="true">▾</span>
  </button>

  <div id="actions" class="nv-dropdown" popover>
    <div class="nv-stack-sm">
      <a href="/edit">Edit</a>
      <a href="/duplicate">Duplicate</a>
    </div>
  </div>
</div>
```

- `--nv-anchor` の値はページ内で一意なアンカー名（`--nv-anchor-*` の形式）にする
- `nv-dropdown-trigger` は `anchor-name: var(--nv-anchor)` でトリガーをアンカー登録する
- `nv-dropdown` は `position-anchor: var(--nv-anchor)` でアンカー配置される

## Optional classes

`src/60-components.css` に存在するクラスのみを使用する。

- `nv-dropdown-trigger` — トリガー側（アンカー名の登録）
- `nv-dropdown` — メニュー側（`min-width: 12rem`、アンカー配置）
- `nv-dropdown-end` — メニューの右端をトリガーの右端に揃える（`inset-inline-end: anchor(right)`）

内部レイアウトには `nv-stack-sm`（リンクリスト）、`nv-text-muted`（補足テキスト）、`nv-cluster` を併用できる。

## Supported interactions

すべてブラウザのネイティブ動作である。

- トリガーのクリックで開閉（`popovertarget` の `toggle`）
- light dismiss: Esc / 外部クリック / 他のpopover表示
- アンカー対応環境ではトリガーの直下（`top: anchor(bottom)`、`inset-inline-start: anchor(left)`）に配置される
- `nv-dropdown-end` 付きでは右端がトリガーの右端に揃う
- メニュー内のリンク・ボタンは通常のタブフォーカスでアクセス可能

## Accessibility

- メニューはリンクリストとして `<a>`（または `<button>`）を並べる。`role="menu"` は**付けない**（理由は Anti-patterns 参照）
- トリガーには `aria-haspopup="true"` を付与する（`examples/dashboard.html` のパターン）
- popoverトリガーでは `aria-expanded` が利用できないため、開閉状態のARIA補完はできない。状態表示が必要な場合は `aria-describedby` で静的な説明を与える
- 破壊的アクション（Delete等）のリンクは色だけに頼らず、文言で危険性を伝える

## Progressive enhancements

- CSS Anchor Positioningは `@supports` ガード内（`src/60-components.css`）でのみ有効。非対応環境では `position: absolute` のアンカー配置を行わず、popoverのデフォルト配置にフォールバックする
- アンカー配置の有無に関わらず、メニューの開閉とリンク操作はすべてのpopover対応環境で機能する

## Fallback behavior

1. **アンカー非対応だがpopover対応**: popoverはトップレイヤーにデフォルト配置される。コンテンツと操作は維持される
2. **popover非対応**: `[popover]` 要素はドキュメントフロー内の通常コンテンツとして表示される。フォールバック時も意味のあるリンクリストになるよう設計する
3. いずれの場合も、トリガーからメニュー内容が「永久に隠れる」ような設計にしない

## Examples

アクションメニュー（`examples/popover.html` のパターン）:

```html
<div style="--nv-anchor: --nv-anchor-actions" class="nv-cluster">
  <button class="nv-dropdown-trigger" popovertarget="actions" aria-haspopup="true">
    Actions <span aria-hidden="true">▾</span>
  </button>

  <div id="actions" class="nv-dropdown" popover>
    <div class="nv-stack-sm">
      <a href="/edit">Edit</a>
      <a href="/duplicate">Duplicate</a>
      <a href="/move">Move to…</a>
      <hr>
      <a href="/delete" style="color: var(--nv-color-danger)">Delete</a>
    </div>
  </div>
</div>
```

右揃えメニュー（`nv-dropdown-end`、`examples/dashboard.html` のアカウントメニュー）:

```html
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
```

## Anti-patterns

- **`role="menu"` を付与する** — menuロールはArrow key・Home/End・Escなどのフルキーボード操作の実装が前提になる。それはJavaScriptなしでは成立しない。リンクリストはネイティブの `<a>` のタブナビゲーションで十分であり、`role="menu"` を付けるとスクリーンリーダーが「正しく動かないメニュー」として扱う
- トリガーに `aria-expanded` を付与する（popoverトリガーでは利用不可。誤った状態通知になる）
- 複数のdropdownに同じ `--nv-anchor` 名を使う（アンカー名の衝突で配置が壊れる。一意な名前を付ける）
- `tabindex` を手動管理してメニュー内をフォーカス順で辿れなくする
- トリガーをdiv / spanで作り `role="button"` を付ける（`<button>` を使う）
- `position: fixed` + クリック検知JSで自作のdropdownを実装する
- メニューを「開いた状態」でサーバーレンダリングし続ける（`popover` 属性の意味がなくなる。初期表示はpopover非対応環境のフォールバックにのみ `popover` を外す等で対応する）
