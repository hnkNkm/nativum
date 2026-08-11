# Button

## Purpose

ネイティブの `<button>` および button型 `<input>` にNativum標準のスタイルを適用する。JavaScriptで動作を再実装せず、ブラウザ標準のボタン操作をそのまま利用する。

## Native primitive

- `<button>`
- `<input type="submit">` / `<input type="reset">` / `<input type="button">`
- `disabled` 属性
- `form` 属性 (`type="submit"` ボタンの所属フォーム指定)

Nativumは `role="button"` による div 再実装を一切行わない。ボタンが必要なら `<button>` を使う。

## Required markup

クラス不要で基本スタイルが適用される。

```html
<button>Save</button>
<button type="submit">Submit</button>
<button type="button">Cancel</button>
```

フォーム内の送信ボタンは `type` を省略可能（デフォルトが `submit`）だが、明示することを推奨する。

## Optional classes

`src/60-components.css` に存在するクラスのみを使用する。

- `nv-primary` — 主要アクション用の強調ボタン
- `nv-danger` — 破壊的操作（削除等）用の警告色ボタン

レイアウト補助として `nv-cluster` / `nv-stack-sm` などを併用できる。

```html
<button class="nv-primary">Create</button>
<button class="nv-danger">Delete</button>
```

## Supported interactions

すべてブラウザのネイティブ動作である。

- クリック / Enter / Space（フォーカス時）による発火
- `:hover` / `:active` の状態変化（`src/60-components.css`）
- `disabled` 属性による非活性化（クリック・フォーカス不可、opacity低下）
- フォーム内 `type="submit"` の場合はフォーム検証と送信を実行
- `type="reset"` はフォームを初期値へ戻す
- `:focus-visible` によるフォーカスリング（`src/30-base.css` のグローバル定義）

## Accessibility

- セマンティクスとキーボード操作は `<button>` がネイティブに提供する。ARIAを追加で付与する必要はない
- ラベルは常に可視テキストで与える。アイコンのみにする場合は `aria-label` で名前を与える（`aria-hidden="true"` の装飾アイコンと併用）
- 非活性化には `disabled` 属性を使う。`aria-disabled` だけでは操作は止まらない
- `nv-primary` / `nv-danger` は背景色・文字色の変化であり、ボタンの意味を変えない。重要な操作は文言と位置でも示す（色だけに依存しない）

## Progressive enhancements

`src/70-motion.css` により、`prefers-reduced-motion: no-preference` の環境でのみ背景色・ボーダー色・opacity等のトランジションが付く。`prefers-reduced-motion: reduce` の環境ではすべて無効化され、状態は色で即時変化する。

## Fallback behavior

高度なCSS機能を必要としない。`<button>` はCSSが読み込まれない環境でもそのまま動作する。

## Examples

```html
<div class="nv-cluster">
  <button>Default</button>
  <button class="nv-primary">Primary</button>
  <button class="nv-danger">Danger</button>
  <button disabled>Disabled</button>
  <input type="submit" value="Input submit">
</div>
```

フォーム内の使用例:

```html
<form action="/projects" method="post">
  <div class="nv-cluster">
    <button class="nv-primary" type="submit">Create project</button>
    <button type="reset">Reset</button>
  </div>
</form>
```

## Anti-patterns

- `<div role="button" tabindex="0">` による再実装（禁止）
- `<a>` をクリックハンドラ的にスタイルしてボタンとして使う（`<a>` はナビゲーション専用。ボタンは `<button>`）
- 実行後の非活性化を `aria-disabled` で表現する（ネイティブの `disabled` を使う）
- `nv-primary` / `nv-danger` を `<a>` に付与してボタン風にする（クラスは `button` / `input[type=...]` セレクタを対象としているため、`<a>` には適用されない。リンクは `a` 要素の標準スタイルを使用する）
- 状態表示（成功/失敗等）のためにボタンの装飾を独自に増やす（`nv-badge` など別要素で表現する）
