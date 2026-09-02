# Popover

## 目的

Popover APIで軽量なオーバーレイ (ヘルプ、アカウント情報等) を実現する。開閉は `popovertarget` / `popovertargetaction` 属性で宣言的に行う。Dropdownの基盤でもある。

## ネイティブprimitive

- `[popover]` 属性 (popover要素。開閉時に付け外ししない)
- `popovertarget` (トリガーが対象の `id` を指定)
- `popovertargetaction="toggle"` / `"show"` / `"hide"` (デフォルトは `toggle`)
- popover showing state / `:popover-open`
- トップレイヤー + light dismiss (デフォルトの `popover="auto"`)
- `popovertarget` が作るinvoker relationship (暗黙の `aria-details` / `aria-expanded` 関係を含む)

## Required markup

```html
<button popovertarget="account">Account</button>

<div id="account" popover>
  <p>アカウント情報や操作へのリンク。</p>
</div>
```

## Nativum classes

popover固有のクラスは `nv-dropdown-*` (別コンポーネント) のみ。内部レイアウトに以下を併用できる:

- `nv-stack-sm` — 縦のリンクリスト
- `nv-cluster` — 横並びの操作ボタン
- `nv-text-muted` — 補足テキスト

## 動作 (ネイティブのinteraction)

- トリガーのクリックで `toggle` / `show` / `hide`
- デフォルトのauto popoverはlight dismissに対応
- トップレイヤー表示
- 開いている状態はブラウザがpopover showing stateとして管理し、CSSでは `:popover-open` を使う
- `popover` content attribute自体は表示状態を表すtoggle属性ではない

## Accessibility

- `<button popovertarget="...">` のネイティブinvoker relationshipを使う
- ブラウザが対象popoverとの暗黙の関連付けとexpanded stateを支援技術へ公開するため、独自の `aria-expanded` stateを手動同期しない
- popover内は本来の意味を持つHTMLで構成する。通常のリンクリストへ `role="menu"` を付けない

## フォールバック

- Popover API非対応環境では `[popover]` 要素は通常のドキュメントフロー内コンテンツとして表示される
- フォールバック時も意味のある内容を保つ

## Anti-patterns

- popover内の通常リンクリストに `role="menu"` を付与する
- ネイティブinvokerのexpanded stateを手動 `aria-expanded` で複製する
- `popover` 属性を開閉状態として付け外しする
- `position: fixed` 等で自作オーバーレイを実装
- 保存結果等の重要な状態をpopoverのみで伝える (`nv-notice` を使う)

## 詳細

この Skill 内の該当 section が正本。
