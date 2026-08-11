# Dropdown

## 目的

Popover API + CSS Anchor Positioningで、トリガーに紐付いたアンカー配置のメニューを実現する。リンクリストをpopoverとして表示し、アンカー非対応環境ではpopoverのデフォルト配置にフォールバックする。

## ネイティブprimitive

- `[popover]` + `popovertarget` (Popover API)
- CSS Anchor Positioning: `anchor-name` / `position-anchor` / `anchor(...)`
- `--nv-anchor` カスタムプロパティ (一意なアンカー名を指定するNativum規約)
- `@supports (anchor-name: ...) and (top: anchor(top))` による機能検出

## Required markup

トリガーとメニューを、アンカー名を共有する同じ親要素に置く。

```html
<div style="--nv-anchor: --nv-anchor-actions">
  <button class="nv-dropdown-trigger" popovertarget="actions" aria-haspopup="true">
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

## Nativum classes

このSkillの references/ に記載されたもののみ:

- `nv-dropdown-trigger` — トリガー側 (`anchor-name: var(--nv-anchor)`)
- `nv-dropdown` — メニュー側 (`min-width: 12rem`、アンカー配置)
- `nv-dropdown-end` — メニューの右端をトリガーの右端に揃える

内部レイアウト: `nv-stack-sm` (リンクリスト), `nv-text-muted` (補足テキスト)。

## 動作 (ネイティブのinteraction)

- トリガーのクリックで開閉 (`popovertarget` の `toggle`)
- light dismiss: Esc / 外部クリック / 他のpopover表示
- アンカー対応環境ではトリガー直下 (`top: anchor(bottom)`, `inset-inline-start: anchor(left)`) に配置
- メニュー内のリンク・ボタンは通常のタブフォーカスでアクセス可能

## フォールバック

1. アンカー非対応だがpopover対応: popoverはトップレイヤーにデフォルト配置。操作は維持
2. popover非対応: 通常のリンクリストとしてドキュメントフローに表示
3. いずれの場合も内容が「永久に隠れる」設計にしない

## Anti-patterns

- `role="menu"` を付与 (Arrow key / Home / End / Esc のフルキーボード操作実装が前提。JSなしでは成立せず、`<a>` のタブナビゲーションで十分)
- トリガーに `aria-expanded` を付与 (popoverトリガーでは利用不可)
- 複数のdropdownで同じ `--nv-anchor` 名を使う (衝突で配置が壊れる)
- `position: fixed` + クリック検知JSで自作dropdownを実装

## 詳細

この Skill 内の該当 section が正本。リポジトリの `docs/components/` は人間向けの詳細版。
