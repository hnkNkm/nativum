# Popover

## Purpose

Popover APIで軽量なオーバーレイ（ヘルプ、アカウント情報等）を実現する。開閉は `popovertarget` / `popovertargetaction` 属性で宣言的に行う。Dropdown（アンカー付きメニュー）の基盤でもある。

## Native primitive

- `[popover]` 属性（popover要素）
- `popovertarget`（トリガー要素が対象の `id` を指定）
- `popovertargetaction="toggle"` / `"show"` / `"hide"`（デフォルトは `toggle`）
- トップレイヤー + light dismiss（Esc / 外部クリック）
- `:popover-open` 疑似クラス

## Required markup

```html
<button popovertarget="account">Account</button>

<div id="account" popover>
  <p>アカウント情報や操作へのリンク。</p>
</div>
```

`[popover]` は `src/60-components.css` の要素セレクタでスタイルされる。popover固有のNativumクラスは `nv-dropdown-*`（別コンポーネント）のみ。

## Optional classes

popover要素の内部レイアウトには以下を併用できる（`src/60-components.css` / `src/40-layout.css` に存在するクラスのみ）。

- `nv-stack-sm` — 縦のリンクリスト
- `nv-cluster` — 横並びの操作ボタン
- `nv-text-muted` — 補足テキスト

Dropdownとして使う場合は `nv-dropdown-trigger` / `nv-dropdown` / `nv-dropdown-end` を使う（[dropdown.md](./dropdown.md) 参照）。

## Supported interactions

すべてブラウザのネイティブ動作である。

- トリガーのクリックで `toggle` / `show` / `hide`
- light dismiss: Escキー、popover外のクリック、他のpopoverの表示で閉じる
- トップレイヤー表示（z-indexを手動管理しない）
- `popover` 属性の有無で開閉が決まり、`:popover-open` でスタイル可能

## Accessibility

- popoverの開閉は `popover` 属性の有無としてスクリーンリーダーに通知される
- popoverトリガーでは `aria-expanded` が利用できないため、開閉状態をARIAで補えない（`examples/popover.html` の注意書き）。状態表示が必要な場合は `aria-describedby` で静的な説明を与える
- トリガーとpopoverの関連付けは `popovertarget` + 対象の `id` で行う。リンク等は通常のフォーカス順でアクセスできる
- popoverはlight dismissで閉じるため、重要な状態遷移（フォーム送信結果等）の表示には使わない。持続的なメッセージは `nv-notice` を使う

## Progressive enhancements

- `src/70-motion.css` により `:popover-open` のフェードと `@starting-style` のトランジションが `prefers-reduced-motion: no-preference` 時のみ有効
- 開閉のアニメーションがなくても内容と操作は維持される

## Fallback behavior

- Popover API非対応環境では、`[popover]` 要素は通常の要素としてドキュメントフローに表示される
- フォールバック時も意味のある内容を保つこと（コンテンツが「隠れたまま」にならない設計にする）
- アンカー付きDropdownとして使う場合、CSS Anchor Positioning非対応環境ではpopoverのデフォルト配置（トップレイヤー中央等）にフォールバックする（[dropdown.md](./dropdown.md)）

## Examples

アカウントpopover（`examples/popover.html` のパターン）:

```html
<div class="nv-cluster">
  <button popovertarget="account">Account</button>
  <button popovertarget="tips" popovertargetaction="show">Show tips</button>
  <button popovertarget="tips" popovertargetaction="hide">Hide tips</button>
</div>

<div id="account" popover>
  <h3>Hanako Tanaka</h3>
  <p class="nv-text-muted">hanako@example.com</p>
  <div class="nv-cluster">
    <a href="/dashboard">Go to dashboard</a>
    <button popovertarget="account" popovertargetaction="hide">Close</button>
  </div>
</div>

<div id="tips" popover>
  <p>Esc・backdropクリック・外部クリックでネイティブに閉じられます。</p>
</div>
```

## Anti-patterns

- `role="menu"` をpopover内のリンクリストに付与する（Arrow keyによるフルキーボード操作の実装が必要になる。リンクリストはそのまま `<a>` のリストでよい。理由は [dropdown.md](./dropdown.md) 参照）
- トリガーに `aria-expanded` を付与する（popoverトリガーでは利用不可）
- `position: fixed` 等で自作のオーバーレイを実装する
- checkbox hack でpopoverを再現する
- 状態が重要な内容（保存結果等）をpopoverのみで伝える（light dismissで閉じるため情報を見失う。`nv-notice` を使用する）
