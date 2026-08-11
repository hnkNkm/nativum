# Details (Disclosure / Accordion)

## 目的

`<details>` / `<summary>` のネイティブ開閉でdisclosureとアコーディオンを実現する。JavaScript stateは持たない。

## ネイティブprimitive

- `<details>` / `<summary>`
- `open` 属性 (サーバー側で初期表示を制御)

## Required markup

```html
<details>
  <summary>Advanced settings</summary>
  <p>本文は details の直接の子に置く。</p>
</details>
```

初期状態で開く場合は `open` 属性を付ける。

## Nativum classes

`src/60-components.css` に存在するもののみ:

- `nv-accordion` — 複数の `<details>` を1本のボーダーでまとめたグループ

```html
<div class="nv-accordion">
  <details open>
    <summary>Billing</summary>
    <p>...</p>
  </details>
  <details>
    <summary>Security</summary>
    <p>...</p>
  </details>
</div>
```

## 動作 (ネイティブのinteraction)

- `<summary>` のクリック / Enter / Space で開閉 (ネイティブのフォーカス可能な開閉ボタン)
- `open` 属性が状態の唯一の真実源 (サーバーレンダリング可能)
- `nv-accordion` では複数の `<details>` が同時に開いてもよい

## フォールバック

- `<details>` / `<summary>` は現行ブラウザで標準動作
- CSSなしでも開閉は機能し、`open` の内容は初期表示される

## Anti-patterns

- `<details>` をタブUIの代用にする (TabsはUnsupported)
- 排他制御 (1つ開いたら他を閉じる) を期待する。排他にはJSが必要で、Nativumのscope外
- checkbox hack や hidden radio で開閉を再現する
- `<summary>` に `role="button"` / `aria-expanded` を追加 (二重通知)

## 詳細

詳細は `../../../../docs/components/details.md` を参照。
