# Details (Disclosure / Accordion)

## Purpose

`<details>` / `<summary>` のネイティブ開閉で開閉式セクション（disclosure）とアコーディオンを実現する。JavaScript stateは持たない。

## Native primitive

- `<details>` / `<summary>`
- `open` 属性（サーバー側で初期表示を制御）

## Required markup

```html
<details>
  <summary>Advanced settings</summary>
  <p>...</p>
</details>
```

`open` 属性を付けると初期状態で開く。

```html
<details open>
  <summary>General</summary>
  <p>...</p>
</details>
```

## Optional classes

`src/60-components.css` に存在するクラスのみを使用する。

- `nv-accordion` — 複数の `<details>` を1本のボーダーでまとめたアコーディオングループ（子の `details` 同士の区切り線を描画）

レイアウト補助として `nv-stack-sm` などを併用できる。

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

## Supported interactions

すべてブラウザのネイティブ動作である。

- `<summary>` のクリック / Enter / Space で開閉（`<summary>` はフォーカス可能なネイティブの開閉ボタン）
- `open` 属性の有無が状態の唯一の真実源（サーバーでレンダリング可能）
- `nv-accordion` は複数の `<details>` が同時に開いてもよい。開閉の排他制御は仕様上保証されない

## Accessibility

- 開閉状態は `expanded` / `hidden` としてスクリーンリーダーにネイティブ通知される。`aria-expanded` や `role="button"` の追加は不要
- `<summary>` 内のテキストがアクセシブルネームになる。内容を説明する見出しテキストを入れる
- `details > :not(summary)` は `src/60-components.css` によりパディングされる。直接の子として本文を置く
- 開閉の状態は矢印（`summary::before`）だけでなくテキストの意味で理解できるようにする

## Progressive enhancements

- 開閉矢印は `summary::before` のCSS疑似要素で描画される（`src/60-components.css`）。`details[open]` で45度回転
- 矢印の回転は `src/70-motion.css` により `prefers-reduced-motion: no-preference` 時のみトランジションする
- `summary:hover` の背景色変化

## Fallback behavior

- `<details>` / `<summary>` は現行ブラウザで標準動作する
- CSSが読み込まれない環境でも開閉は機能し、`open` 属性の内容は初期表示される
- 動作にJavaScriptを一切必要としない

## Examples

単一の disclosure:

```html
<details>
  <summary>Advanced settings</summary>
  <p>この設定は通常は隠れています。開くと内容が表示されます。</p>
</details>
```

アコーディオン（`examples/index.html` のパターン）:

```html
<div class="nv-accordion">
  <details open>
    <summary>General</summary>
    <p>基本設定についての説明。</p>
  </details>
  <details>
    <summary>Notifications</summary>
    <p>通知設定についての説明。</p>
  </details>
  <details>
    <summary>Billing</summary>
    <p>請求設定についての説明。</p>
  </details>
</div>
```

## Anti-patterns

- `<details>` をタブUIの代用に使う（TabsはUnsupported。ネイティブのタブパターンが存在しないためNativumは提供しない）
- 排他制御（1つ開いたら他を閉じる）を「実装できる」と期待する。排他にはJavaScriptが必要であり、Nativumのscope外。同時複数オープンを許容する設計にする
- checkbox hack や hidden radio で開閉状態を再現する
- `<summary>` に `role="button"` や `aria-expanded` を追加する（ネイティブで通知済み。二重通知になる）
- `summary` 以外の要素をクリック対象にする（キーボード操作が失われる）
