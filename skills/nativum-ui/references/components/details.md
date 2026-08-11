# Details (Disclosure / Accordion)

## 目的

`<details>` / `<summary>` のネイティブ開閉でdisclosureとアコーディオンを実現する。JavaScript stateは持たない。排他的なアコーディオンも `details[name]` のネイティブグループを使う。

## ネイティブprimitive

- `<details>` / `<summary>`
- `open` 属性 (サーバー側で初期表示を制御)
- `name` 属性 (同じ非空値の `<details>` を排他的なグループにする)

## Required markup

通常の disclosure:

```html
<details>
  <summary>Advanced settings</summary>
  <p>本文は details の直接の子に置く。</p>
</details>
```

複数同時オープンを許容する場合は `name` を付けない。

排他的にする場合は同じ `name` を使う:

```html
<div class="nv-accordion">
  <details name="settings" open>
    <summary>Billing</summary>
    <p>...</p>
  </details>
  <details name="settings">
    <summary>Security</summary>
    <p>...</p>
  </details>
</div>
```

同じ `name` グループの初期markupでは `open` を複数に付けない。

## Nativum classes

このSkillの references/ に記載されたもののみ:

- `nv-accordion` — 複数の `<details>` を1本のボーダーでまとめたグループ

`nv-accordion` は排他性を実装しない。排他的にしたい場合はHTMLの `name` 属性を使う。

## 動作 (ネイティブのinteraction)

- `<summary>` のクリック / Enter / Space で開閉
- `open` 属性が各 `<details>` の状態の真実源
- `name` なしでは複数同時オープン可能
- 同じ非空の `name` を持つ `<details>` は排他的で、最大1つだけ開く

## フォールバック

- `<details>` / `<summary>` は現行ブラウザで標準動作
- `details[name]` の排他性が無い古い環境でも、各 `<details>` は独立した disclosure として操作可能
- CSSなしでも開閉は機能する

## Anti-patterns

- `<details>` をタブUIの代用にする (TabsはUnsupported)
- 排他制御のためだけにJavaScriptで `open` を管理する (`details[name]` を使う)
- 比較のため複数を同時に開く必要があるUIへ同じ `name` を付ける
- 同じ `name` グループで複数の `<details open>` を初期markupに書く
- checkbox hack や hidden radio で開閉を再現する
- `<summary>` に `role="button"` / `aria-expanded` を追加する

## 詳細

この Skill 内の該当 section が正本。リポジトリの `docs/components/` は人間向けの詳細版。
