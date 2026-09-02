# Dropdown

## 目的

Popover API + CSS Anchor Positioningで、トリガーに紐付いたアンカー配置のdropdownを実現する。Nativumの標準パターンは通常のリンク / ボタンをpopoverに並べるものであり、ARIA `menu` widgetではない。

## ネイティブprimitive

- `[popover]` + `popovertarget` (Popover API)
- `popovertarget` のネイティブinvoker relationship (暗黙のexpanded stateを含む)
- CSS Anchor Positioning: `anchor-name` / `position-anchor` / `anchor(...)`
- `--nv-anchor` カスタムプロパティ (一意なアンカー名を指定するNativum規約)
- `@supports (anchor-name: ...) and (top: anchor(top))` による機能検出

## Required markup

トリガーとdropdownを、アンカー名を共有する同じ親要素に置く。

```html
<div style="--nv-anchor: --nv-anchor-actions">
  <button class="nv-dropdown-trigger" popovertarget="actions">
    Actions
  </button>

  <div id="actions" class="nv-dropdown" popover>
    <div class="nv-stack-sm">
      <a href="/edit">Edit</a>
      <a href="/delete">Delete</a>
    </div>
  </div>
</div>
```

`--nv-anchor` の値はページ内で一意 (`--nv-anchor-*` の形式) にする。
通常のリンクリストpopupへ `aria-haspopup="true"` は付けない。ARIAでは `true` は `menu` と同義で、Nativum標準dropdownはmenu widgetではない。

## Nativum classes

このSkillの references/ に記載されたもののみ:

- `nv-dropdown-trigger` — トリガー側 (`anchor-name: var(--nv-anchor)`)
- `nv-dropdown` — dropdown側 (`min-width: 12rem`、アンカー配置)
- `nv-dropdown-end` — dropdownの右端をトリガーの右端に揃える

内部レイアウト: `nv-stack-sm` (リンクリスト), `nv-text-muted` (補足テキスト)。

## 動作 (ネイティブのinteraction)

- トリガーのクリックで開閉 (`popovertarget` の `toggle`)
- デフォルトのauto popoverはlight dismissに対応
- invoker relationshipによりexpanded stateはブラウザが支援技術へ公開する
- アンカー対応環境ではトリガー直下に配置
- リンク・ボタンは通常のタブフォーカスでアクセス可能

## Accessibility

- 通常のリンク / ボタンの集合として扱い、`role="menu"` / `role="menuitem"` を付けない
- ネイティブinvokerのexpanded stateを独自 `aria-expanded` で手動同期しない
- `aria-haspopup="true"` はmenu popupを意味するため、role-lessなリンクリストpopupでは使わない
- 本物のARIA menu widgetに必要なmenu rolesとArrow key等のキーボード実装はNativum Coreの標準dropdownパターン外

## フォールバック

1. アンカー非対応だがpopover対応: popoverはトップレイヤーにデフォルト配置。操作は維持
2. popover非対応: 通常のリンクリストとしてドキュメントフローに表示
3. いずれの場合も内容が「永久に隠れる」設計にしない

## Anti-patterns

- 通常リンクリストに `role="menu"` を付与する
- 通常リンクリストpopupのトリガーへ `aria-haspopup="true"` を付ける (`true` は `menu` と同義)
- ネイティブinvokerのexpanded stateを手動 `aria-expanded` で複製する
- 複数のdropdownで同じ `--nv-anchor` 名を使う
- `position: fixed` + クリック検知JSで自作dropdownを実装

## 詳細

この Skill 内の該当 section が正本。
