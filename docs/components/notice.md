# Notice

## Purpose

ページ内の状態メッセージ（情報・成功・警告・エラー）を、色とテキストで伝える。フォーム全体のエラーや保存結果など、特定のコントロールに紐づかないメッセージに使う。

## Native primitive

- `<div>`（汎用コンテナ）
- `role="status"`（politeな状態変化。フォーカスを奪わない）
- `role="alert"`（即時の注意を要するエラー）

noticeはネイティブのrole（`status` / `alert`）を使って支援技術へ伝える。`role` の再実装はしない。

## Required markup

`nv-notice` クラスと、意味に応じたvariantクラスを付与する。

```html
<div class="nv-notice nv-notice-info" role="status">Information notice.</div>
<div class="nv-notice nv-notice-danger" role="alert">This action cannot be undone.</div>
```

## Optional classes

`src/60-components.css` に存在するクラスのみを使用する。

- `nv-notice` — 基本のnotice（subtle背景 + ボーダー + 角丸 + 左アクセントボーダー + 下マージン）
- `nv-notice-info` / `nv-notice-success` / `nv-notice-warning` / `nv-notice-danger` — アクセント色（`border-inline-start-color`）のみを変更するvariant

variantは非ソリッド系のアクセント色（`--nv-color-*`）を **`border-inline-start-color` のみ** に使用する。背景色・文字色は変化しない。

```html
<div class="nv-notice nv-notice-info" role="status">...</div>
<div class="nv-notice nv-notice-success" role="status">...</div>
<div class="nv-notice nv-notice-warning" role="status">...</div>
<div class="nv-notice nv-notice-danger" role="alert">...</div>
```

`nv-notice` は `margin-block-end: var(--nv-space-4)` を内蔵する。`nv-stack` / `nv-card` の内側に置くと、親の `gap` やパディングとマージンが二重になることがある（`nv-card` は `> :last-child` の下マージンを0にするが、途中の要素では重なる）。必要に応じて `style="margin-block-end: 0"` などで打ち消す。

## Supported interactions

- notice自体にinteractionはない
- `role="status"` はフォーカスを奪わず、状態変化をpoliteに通知する
- `role="alert"` は即時・優先的に通知する（取り消せない操作の警告など）

## Accessibility

- `role="status"` と `role="alert"` を使い分ける。フォームのバリデーションエラーは `role="status"`（`role="alert"` は即時・優先通知が必要な場合に限る）
- 色だけに依存しない。必ず可視テキストでメッセージを伝える
- アクセント色は左ボーダーのみに使い、テキスト自体は通常の文字色を保つ

## Progressive enhancements

- 左アクセントボーダー（`border-inline-start`）は `src/60-components.css` の静的ルール

## Fallback behavior

- 背景色・ボーダー・角丸のみ。CSSなしでもテキストはそのまま表示される
- `role="status"` / `role="alert"` はHTML属性であり、CSSなしでも支援技術への通知は機能する

## Examples

```html
<div class="nv-notice nv-notice-info" role="status">Information notice.</div>
<div class="nv-notice nv-notice-success" role="status">Operation completed successfully.</div>
<div class="nv-notice nv-notice-warning" role="status">Your session expires soon.</div>
<div class="nv-notice nv-notice-danger" role="alert">This action cannot be undone.</div>
```

フォーム全体のエラー（`docs/patterns/login-form.md` 参照）:

```html
<div class="nv-notice nv-notice-danger" role="status">
  メールアドレスまたはパスワードが正しくありません。
</div>
```

## Anti-patterns

- フォームのバリデーションエラーに `role="alert"` を使う（`role="status"` 付き `.nv-notice` を使う）
- 色だけで状態を伝える（テキストを必ず併記する）
- `nv-notice` の内蔵 `margin-block-end` を `nv-stack` / `nv-card` 内でそのままにして二重マージンを作る
- noticeのvariantクラスを発明する（`nv-notice-neutral` 等は存在しない）
- 特定のコントロールに紐づくエラーをnoticeで表示する（`nv-field-error` を使う）
