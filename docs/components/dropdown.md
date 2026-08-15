# Dropdown

## Purpose

Popover API + CSS Anchor Positioning で、トリガーに紐付いたアンカー配置のdropdownを実現する。Nativumの標準パターンは、シンプルなリンクリスト（またはボタンリスト）をpopoverとして表示するものであり、ARIA `menu` widgetを実装するものではない。アンカー非対応環境ではpopoverのデフォルト配置にフォールバックする。

## Native primitive

- `[popover]` + `popovertarget`（Popover API）
- `popovertarget` が作るネイティブinvoker relationship（暗黙のexpanded stateを含む）
- CSS Anchor Positioning: `anchor-name` / `position-anchor` / `anchor(...)`
- `--nv-anchor` カスタムプロパティ（一意なアンカー名を指定するNativum規約）
- `@supports (anchor-name: ...) and (top: anchor(top))` による機能検出（`src/60-components.css`）

## Required markup

トリガーとdropdown内容を同じスコープ（アンカー名を共有する親要素）に置く。

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
- 通常リンクリストのpopupには `aria-haspopup="true"` を付けない。ARIAでは `true` は `menu` と同義であり、popup側がmenu widgetではないため

## Optional classes

`src/60-components.css` に存在するクラスのみを使用する。

- `nv-dropdown-trigger` — トリガー側（アンカー名の登録）
- `nv-dropdown` — dropdown側（`min-width: 12rem`、アンカー配置）
- `nv-dropdown-end` — dropdownの右端をトリガーの右端に揃える（`inset-inline-end: anchor(end)`）

内部レイアウトには `nv-stack-sm`（リンクリスト）、`nv-text-muted`（補足テキスト）、`nv-cluster` を併用できる。

## Supported interactions

すべてブラウザのネイティブ動作である。

- トリガーのクリックで開閉（`popovertarget` の `toggle`）
- デフォルトのauto popoverはlight dismissに対応
- `popovertarget` のinvoker relationshipにより、開閉状態はブラウザが支援技術へ公開する
- アンカー対応環境ではトリガーの直下（`top: anchor(bottom)`、`inset-inline-start: anchor(start)`）に配置される
- `nv-dropdown-end` 付きでは右端がトリガーの右端に揃う
- リンク・ボタンは通常のタブフォーカスでアクセス可能

## Accessibility

- Nativumの標準dropdownは通常のリンク / ボタンの集合であり、`role="menu"` / `role="menuitem"` を使わない
- `<button popovertarget="...">` のネイティブinvoker relationshipを使い、独自 `aria-expanded` stateを手動同期しない
- `aria-haspopup` はpopupのARIA roleを宣言する属性である。`aria-haspopup="true"` は `menu` と同義なので、role-lessな通常リンクリストpopupへは付けない
- 本当にARIA menu widgetを実装する場合はpopup側の `role="menu"` とmenuitem roles、Arrow key/Home/End等を含む対応するキーボード操作が必要であり、Nativum Coreの標準dropdownパターン外とする
- 破壊的アクション（Delete等）は色だけに頼らず、文言で危険性を伝える

## Progressive enhancements

- CSS Anchor Positioningは `@supports` ガード内（`src/60-components.css`）でのみ有効。非対応環境ではアンカー配置を行わず、popoverのデフォルト配置にフォールバックする
- アンカー配置の有無に関わらず、popoverの開閉とリンク操作は維持される

## Fallback behavior

1. **アンカー非対応だがpopover対応**: popoverはトップレイヤーにデフォルト配置される。コンテンツと操作は維持される
2. **popover非対応**: `[popover]` 要素はドキュメントフロー内の通常コンテンツとして表示される。フォールバック時も意味のあるリンクリストになるよう設計する
3. いずれの場合も内容が「永久に隠れる」設計にしない

## Examples

アクションdropdown（`examples/popover.html` のパターン）:

```html
<div style="--nv-anchor: --nv-anchor-actions" class="nv-cluster">
  <button class="nv-dropdown-trigger" popovertarget="actions">
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

右揃えdropdown（`nv-dropdown-end`）:

```html
<span style="--nv-anchor: --nv-anchor-account">
  <button class="nv-dropdown-trigger" popovertarget="account-menu">
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

- 通常リンクリストに **`role="menu"` を付与する**（menu widget固有のフォーカス・キーボード操作を実装していないため）
- role-lessな通常リンクリストpopupのトリガーへ `aria-haspopup="true"` を付ける（`true` は `menu` と同義で、popup semanticsと一致しない）
- ネイティブ `popovertarget` のexpanded stateを独自 `aria-expanded` で手動同期する
- 複数のdropdownに同じ `--nv-anchor` 名を使う（アンカー名の衝突で配置が壊れる。一意な名前を付ける）
- `tabindex` を手動管理して通常のリンク / ボタンのフォーカス順を壊す
- トリガーをdiv / spanで作り `role="button"` を付ける（`<button>` を使う）
- `position: fixed` + クリック検知JSで自作のdropdownを実装する
