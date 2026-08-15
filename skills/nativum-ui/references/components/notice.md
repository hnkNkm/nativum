# Notice

## 目的

ページ内の状態メッセージ (情報・成功・警告・エラー) を色とテキストで伝える。特定のコントロールに紐づかないメッセージに使う。

## ネイティブprimitive

- `<div>` (汎用コンテナ)
- `role="status"` (polite。フォーカスを奪わない)
- `role="alert"` (即時の注意を要するエラー)

## Required markup

```html
<div class="nv-notice nv-notice-info" role="status">Information notice.</div>
<div class="nv-notice nv-notice-danger" role="alert">This action cannot be undone.</div>
```

## Nativum classes

このSkillの references/ に記載されたもののみ:

- `nv-notice` — 基本のnotice (subtle背景 + ボーダー + 角丸 + 左アクセントボーダー + `margin-block-end`)
- `nv-notice-info` / `nv-notice-success` / `nv-notice-warning` / `nv-notice-danger` — アクセント色 (`border-inline-start-color`) のみを変更

variantは非ソリッド系の `--nv-color-*` を **`border-inline-start-color` のみ** に使う。背景色・文字色は変化しない。

```html
<div class="nv-notice nv-notice-info" role="status">...</div>
<div class="nv-notice nv-notice-success" role="status">...</div>
<div class="nv-notice nv-notice-warning" role="status">...</div>
<div class="nv-notice nv-notice-danger" role="alert">...</div>
```

## 動作 (ネイティブのinteraction)

- `role="status"` はフォーカスを奪わずpoliteに通知する
- `role="alert"` は即時・優先的に通知する
- notice自体にinteractionはない

## フォールバック

- ボーダー・背景色のみ。CSSなしでもテキストは表示される

## Anti-patterns

- フォームのバリデーションエラーに `role="alert"` を使う (`role="status"` を使う)
- 色だけで状態を伝える (テキストを必ず併記する)
- `nv-notice` の `margin-block-end` を `nv-stack` / `nv-card` 内でそのままにして二重マージンを作る
- variantクラスを発明する

## 詳細

この Skill 内の該当 section が正本。リポジトリの `docs/components/` は人間向けの詳細版。
