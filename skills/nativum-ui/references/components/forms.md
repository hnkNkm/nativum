# Forms

## 目的

ネイティブのform control (input / textarea / select / checkbox / radio / range / progress / meter) に標準スタイルを適用し、ネイティブ検証をそのまま使う。状態管理・検証はブラウザとサーバーに任せる。

## ネイティブprimitive

- `<form method="post" action="...">` (通常送信)
- `<label for>` + コントロールの `id`
- `<input>` (text / email / password / url / tel / search / number / date / datetime-local / month / week / time / checkbox / radio / range)
- `<textarea>` / `<select>` / `<option>` / `<fieldset>` / `<legend>`
- `<progress>` / `<meter>`
- 検証属性 (`required` / `minlength` / `type="email"` 等)
- `:user-invalid` / `aria-invalid` / `disabled` / `placeholder`

## Required markup

ラベルとコントロールを必ず関連付ける。

```html
<div class="nv-field">
  <label for="email">Email</label>
  <input id="email" name="email" type="email" required>
</div>
```

## Nativum classes

`src/50-forms.css` に存在するもののみ:

- `nv-field` — ラベル + コントロール + メッセージの縦グループ
- `nv-field-hint` — 補助説明 (`aria-describedby` で関連付ける)
- `nv-field-error` — エラーメッセージ (`aria-invalid="true"` と併用)

レイアウト補助: `nv-stack-sm` (チェックボックス群の縦並び), `nv-cluster` (ボタン群), `nv-container-narrow`。

## 動作 (ネイティブのinteraction)

- `required` / `type` / `minlength` 等で送信時にブラウザが検証しブロック
- `:user-invalid` はユーザー操作後にのみ適用されるネイティブ疑似クラス (赤ボーダー)
- `[aria-invalid="true"]` はサーバー側検証済みエラーの表示に使う
- `fieldset[disabled]` でグループ全体を非活性化
- select は `appearance: none` + `--nv-select-icon` データURI矢印

## フォールバック

- すべて標準HTMLなので、CSSなしでも送信できる
- ネイティブ検証未対応環境でも `required` 等はHTMLとして存在し、サーバー側で再検証する
- select の矢印はデータURIのため外部依存なし

## Anti-patterns

- checkbox / radio を状態装置にする「CSS checkbox hack / radio hack」
- `novalidate` でネイティブ検証を無効化しJSで独自検証
- `placeholder` をラベル代わりにする
- エラーを色のみで伝える (`nv-field-error` のテキストを併用)

## 詳細

詳細は `../../../../docs/components/forms.md` を参照。
