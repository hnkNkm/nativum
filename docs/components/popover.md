# Popover

## Purpose

Popover APIで軽量なオーバーレイ（ヘルプ、アカウント情報等）を実現する。開閉は `popovertarget` / `popovertargetaction` 属性で宣言的に行う。Dropdown（アンカー付きリンクリスト等）の基盤でもある。

## Native primitive

- `[popover]` 属性（popover要素。属性自体は開閉時に付け外しされない）
- `popovertarget`（トリガー要素が対象の `id` を指定）
- `popovertargetaction="toggle"` / `"show"` / `"hide"`（デフォルトは `toggle`）
- popover showing state + `:popover-open` 疑似クラス
- トップレイヤー + light dismiss（デフォルトの `popover="auto"` では Esc / 外部クリック等）
- `popovertarget` が作るinvoker relationship（支援技術向けの暗黙 `aria-details` / `aria-expanded` 関係と、論理的なフォーカス順）

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
- デフォルトの `popover="auto"` はlight dismissに対応する
- トップレイヤー表示（z-indexを手動管理しない）
- 開いている状態はpopover showing stateとしてブラウザが管理し、CSSでは `:popover-open` でスタイル可能
- `popover` content attributeは「この要素がpopoverである」ことを宣言する設定であり、表示中だけ存在する状態属性ではない

## Accessibility

- `<button popovertarget="...">` のネイティブinvoker relationshipを使う。ブラウザは対象popoverとの暗黙の関連付けとexpanded stateを支援技術へ公開する
- ネイティブinvokerの開閉状態を手動の `aria-expanded` で複製しない。ブラウザが管理する状態とずれる独自stateを作らない
- `popovertarget` と対象の `id` でトリガーとpopoverを関連付ける。可能ならpopoverはトリガーの近くに置き、読み上げ・フォーカス順も自然になる構造にする
- popover内の内容には本来の意味を持つHTMLを使う。単なるリンクリストへ `role="menu"` を付けない
- popoverはlight dismissされ得るため、保存結果など持続的に伝える必要がある状態は `nv-notice` 等の通常コンテンツで表現する

## Progressive enhancements

- `src/70-motion.css` により `:popover-open` のフェードと `@starting-style` のトランジションが `prefers-reduced-motion: no-preference` 時のみ有効
- 開閉のアニメーションがなくても内容と操作は維持される

## Fallback behavior

- Popover API非対応環境では、`[popover]` は未知の属性として扱われ、要素は通常のドキュメントフロー内コンテンツとして表示される
- フォールバック時も意味のある内容を保つこと（コンテンツが「隠れたまま」にならない設計にする）
- フェードは `@supports selector(:popover-open)` でゲートされ、非対応環境では `[popover]` に `opacity: 0` を付けない
- アンカー付きDropdownとして使う場合、CSS Anchor Positioning非対応環境ではpopoverのデフォルト配置にフォールバックする（[dropdown.md](./dropdown.md)）

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
  <p>Escやpopover外のクリック等でネイティブにlight dismissできます。</p>
</div>
```

## Anti-patterns

- `role="menu"` をpopover内の通常リンクリストに付与する（menu widget固有のキーボード操作を実装していないため）
- ネイティブ `popovertarget` のexpanded stateを独自 `aria-expanded` stateで手動同期する
- `popover` 属性の有無を開閉状態として付け外しする（表示状態はブラウザが管理するpopover showing state / `:popover-open` を使う）
- `position: fixed` 等で自作のオーバーレイを実装する
- checkbox hack でpopoverを再現する
- 状態が重要な内容（保存結果等）をpopoverのみで伝える（light dismissで閉じるため情報を見失う。`nv-notice` を使用する）
