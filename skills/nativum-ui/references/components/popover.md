# Popover

## 目的

Popover APIで軽量なオーバーレイ (ヘルプ、アカウント情報等) を実現する。開閉は `popovertarget` / `popovertargetaction` 属性で宣言的に行う。Dropdownの基盤でもある。

## ネイティブprimitive

- `[popover]` 属性 (popover要素)
- `popovertarget` (トリガーが対象の `id` を指定)
- `popovertargetaction="toggle"` / `"show"` / `"hide"` (デフォルトは `toggle`)
- トップレイヤー + light dismiss (Esc / 外部クリック)
- `:popover-open` 疑似クラス

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
- light dismiss: Escキー、popover外クリック、他のpopover表示で閉じる
- トップレイヤー表示 (z-index管理は不要)
- `:popover-open` でスタイル可能

## フォールバック

- Popover API非対応環境では `[popover]` 要素はドキュメントフロー内の通常要素として表示される
- フォールバック時も意味のある内容を保つ (「隠れたまま」にしない)

## Anti-patterns

- popover内のリンクリストに `role="menu"` を付与 (Arrow key等のフルキーボード操作実装が必要になり、JSなしでは成立しない。素の `<a>` リストでよい)
- トリガーに `aria-expanded` を付与 (popoverトリガーでは利用不可)
- `position: fixed` 等で自作オーバーレイを実装
- 保存結果等の重要な状態をpopoverのみで伝える (light dismissで閉じるため。`nv-notice` を使う)

## 詳細

詳細は `../../../../docs/components/popover.md` を参照。
