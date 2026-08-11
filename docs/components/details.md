# Details (Disclosure / Accordion)

## Purpose

`<details>` / `<summary>` のネイティブ開閉で開閉式セクション（disclosure）とアコーディオンを実現する。JavaScript stateは持たない。排他的なアコーディオンが必要な場合も、同じ `name` を持つ `<details>` をグループ化してブラウザのネイティブ動作を使う。

## Native primitive

- `<details>` / `<summary>`
- `open` 属性（サーバー側で初期表示を制御）
- `name` 属性（同じ非空の値を持つ `<details>` を排他的なグループにする）

## Required markup

通常の disclosure:

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

複数セクションを同時に開ける通常のアコーディオンでは `name` を付けない。

排他的なアコーディオンが必要なら、各 `<details>` に同じ `name` を付ける。1つを開くと、同じグループ内で開いていた別の `<details>` はブラウザによって閉じられる。

```html
<div class="nv-accordion">
  <details name="settings" open>
    <summary>General</summary>
    <p>...</p>
  </details>
  <details name="settings">
    <summary>Security</summary>
    <p>...</p>
  </details>
  <details name="settings">
    <summary>Notifications</summary>
    <p>...</p>
  </details>
</div>
```

同じ `name` グループの初期markupでは、`open` を複数要素へ同時に付けない。

## Optional classes

`src/60-components.css` に存在するクラスのみを使用する。

- `nv-accordion` — 複数の `<details>` を1本のボーダーでまとめたアコーディオングループ（子の `details` 同士の区切り線を描画）

`nv-accordion` は開閉方式を決めない。複数同時オープンを許容するか、`details[name]` で排他的にするかはHTMLの意味と利用目的で選ぶ。

レイアウト補助として `nv-stack-sm` などを併用できる。

## Supported interactions

すべてブラウザのネイティブ動作である。

- `<summary>` のクリック / Enter / Space で開閉（`<summary>` はフォーカス可能なネイティブの開閉コントロール）
- `open` 属性の有無が各 `<details>` の状態の真実源（サーバーでレンダリング可能）
- `name` が無い複数の `<details>` は同時に開ける
- 同じ非空の `name` を持つ `<details>` は排他的なグループになり、開けるのは最大1つ

## Accessibility

- 開閉状態はブラウザから支援技術へネイティブに公開される。`aria-expanded` や `role="button"` の追加は不要
- `<summary>` 内のテキストがアクセシブルネームになる。内容を説明する見出しテキストを入れる
- `details > :not(summary)` は `src/60-components.css` によりパディングされる。直接の子として本文を置く
- 開閉の状態は矢印（`summary::before`）だけでなくテキストの意味で理解できるようにする
- 排他的な `details[name]` は表示領域を節約できる一方、複数内容を比較したい利用者には不便になり得る。排他性が本当に必要な場合だけ使う

## Progressive enhancements

- 開閉矢印は `summary::before` のCSS疑似要素で描画される（`src/60-components.css`）。`details[open]` で45度回転
- 矢印の回転は `src/70-motion.css` により `prefers-reduced-motion: no-preference` 時のみトランジションする
- `summary:hover` の背景色変化

## Fallback behavior

- `<details>` / `<summary>` は現行ブラウザで標準動作する
- `details[name]` は現行の主要ブラウザでネイティブの排他グループとして動作する。古い環境で排他性が利用できなくても各 `<details>` 自体は独立した disclosure として操作できる
- CSSが読み込まれない環境でも開閉は機能する
- 動作にJavaScriptを必要としない

## Examples

複数同時オープン可能なアコーディオン:

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
</div>
```

排他的なアコーディオン:

```html
<div class="nv-accordion">
  <details name="account-settings" open>
    <summary>General</summary>
    <p>基本設定についての説明。</p>
  </details>
  <details name="account-settings">
    <summary>Notifications</summary>
    <p>通知設定についての説明。</p>
  </details>
  <details name="account-settings">
    <summary>Billing</summary>
    <p>請求設定についての説明。</p>
  </details>
</div>
```

## Anti-patterns

- `<details>` をタブUIの代用に使う（TabsはUnsupported）
- 排他制御のためだけにJavaScriptで `open` を付け外しする（同じ `name` を使う）
- 比較のため複数セクションを同時に開く必要があるUIへ、無条件に同じ `name` を付ける
- 同じ `name` グループで複数の `<details open>` を初期markupに書く
- checkbox hack や hidden radio で開閉状態を再現する
- `<summary>` に `role="button"` や `aria-expanded` を追加する（ネイティブの意味・状態公開を利用する）
- `summary` 以外の要素をクリック対象として再実装する
