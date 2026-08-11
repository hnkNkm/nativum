# Forms

## Purpose

ネイティブのform control（input / textarea / select / checkbox / radio / range / progress / meter）にNativum標準スタイルを適用し、ネイティブ検証をそのまま利用する。フォームの状態管理・検証はブラウザとサーバーに任せる。

## Native primitive

- `<form>`（`method="post"` + `action` による通常送信）
- `<label>` + `for` / コントロールの `id`
- `<input>`（text / email / password / url / tel / search / number / date / datetime-local / month / week / time / checkbox / radio / range）
- `<textarea>` / `<select>` / `<option>`
- `<fieldset>` / `<legend>`（グループ化と `disabled`）
- `<progress>` / `<meter>`
- 検証属性（`required` / `minlength` / `type="email"` 等）
- `:user-invalid` 疑似クラス / `aria-invalid` 属性
- `disabled` / `placeholder`

## Required markup

ラベルとコントロールを正しく関連付ける。

```html
<div class="nv-field">
  <label for="email">Email</label>
  <input id="email" name="email" type="email" required>
</div>
```

## Optional classes

`src/50-forms.css` に存在するクラスのみを使用する。

- `nv-field` — ラベル + コントロール + メッセージの縦グループ（下端マージン付き）
- `nv-field-hint` — 補助説明（`input` の `aria-describedby` で関連付ける）
- `nv-field-error` — エラーメッセージ（`input` の `aria-invalid="true"` と併用）

レイアウト補助として `nv-stack-sm`（チェックボックス群の縦並び）、`nv-cluster`（送信ボタン群）、`nv-container-narrow` を併用できる。

## Supported interactions

すべてネイティブ動作である。

- 検証は `required` / `type` / `minlength` 等の属性で行われ、送信時にブラウザがブロックする
- `:user-invalid` はユーザーが操作した後にのみ適用されるネイティブ疑似クラス（`src/50-forms.css` が赤いボーダーを付与）
- `[aria-invalid="true"]` はサーバー側で検証済みエラーをレンダリングする場合のスタイル
- `fieldset[disabled]` はグループ全体を非活性化（opacity低下 + `pointer-events: none`）
- `<select>` は `appearance: none` + トークン `--nv-select-icon` のデータURI矢印で描画される
- checkbox / radio / range / progress / meter は `accent-color` でテーマ色になる

## Accessibility

- すべてのコントロールに `<label for>` またはラッピング `<label>` を付ける。`placeholder` はラベルの代わりにならない
- ヒント・エラーは `aria-describedby` でコントロールに紐付ける（`examples/forms.html` の `server-email-error` パターン）
- エラーは `nv-field-error` のテキストで伝える。色（`--nv-color-danger`）だけに依存しない
- 必須・任意の区別が必要なら `<span class="nv-text-muted">` 等で明示する（`*` のみで表すのは避ける）
- ラジオグループは必ず `<fieldset>` + `<legend>` でグループ化する
- 検証をバイパスするためだけに `novalidate` を付与しない（サーバー側検証との二重化は `aria-invalid` で表現する）

## Progressive enhancements

- `:user-invalid` の赤ボーダーは、ユーザー操作後にのみ表示されるネイティブ機能（`src/50-forms.css`）
- `:focus-visible` 時のアウトラインが `--nv-color-danger` になる（エラー状態）
- `src/70-motion.css` のトランジションが `prefers-reduced-motion: no-preference` 時のみ有効

## Fallback behavior

- すべて標準HTMLで構成されるため、CSSが読み込まれなくてもフォームは送信できる
- ネイティブ検証に対応しない環境でも `required` 属性はHTMLとして存在し、サーバー側で再検証する
- `--nv-select-icon` データURIは `src/20-tokens.css` に焼き込まれており、外部依存はない

## Examples

テキストフィールド + ヒント:

```html
<form action="/settings" method="post">
  <div class="nv-field">
    <label for="name">Name</label>
    <input id="name" name="name" type="text" required aria-describedby="name-hint">
    <span class="nv-field-hint" id="name-hint">公開プロフィールに表示されます。</span>
  </div>

  <div class="nv-field">
    <label for="email">Email</label>
    <input id="email" name="email" type="email" required>
  </div>

  <div class="nv-field">
    <label>Notification</label>
    <div class="nv-stack-sm">
      <label><input type="checkbox" name="digest" checked> Email digest</label>
      <label><input type="checkbox" name="weekly"> Weekly report</label>
    </div>
  </div>

  <fieldset>
    <legend>Account type</legend>
    <div class="nv-stack-sm">
      <label><input type="radio" name="type" value="personal" checked> Personal</label>
      <label><input type="radio" name="type" value="business"> Business</label>
    </div>
  </fieldset>

  <div class="nv-cluster">
    <button class="nv-primary" type="submit">Submit</button>
    <button type="reset">Reset</button>
  </div>
</form>
```

サーバー側検証エラー（`examples/forms.html` のパターン）:

```html
<div class="nv-field">
  <label for="server-email">Email</label>
  <input id="server-email" name="email" type="email" value="not-an-email"
         aria-invalid="true" aria-describedby="server-email-error" required>
  <span class="nv-field-error" id="server-email-error">このメールアドレスは既に登録されています。</span>
</div>
```

進捗表示:

```html
<label for="upload">Upload progress</label>
<progress id="upload" max="100" value="65">65%</progress>
<label for="disk">Disk usage</label>
<meter id="disk" min="0" max="100" value="80" low="70" high="90" optimum="20">80%</meter>
```

## Anti-patterns

- checkbox / radio を状態装置として悪用する「CSS checkbox hack / radio hack」（禁止）
- ネイティブ検証を無効化し、JavaScriptで独自検証する（`required` 等のネイティブ属性を使う）
- `role="button"` 等の div でコントロールを再実装する
- `label` なしでコントロールだけを配置する
- `::placeholder` をラベル代わりにする（`src/50-forms.css` は placeholder を `--nv-color-text-muted` にスタイルするだけで、意味は持たない）
- エラー状態を色のみ（`:user-invalid` の赤ボーダー）で伝える。必ず `nv-field-error` のテキストを併用する
