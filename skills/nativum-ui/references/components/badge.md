# Badge

## 目的

短い状態ラベル (ステータス・件数・分類) をインライン要素で表現する。色だけでなくテキストで意味を伝える。

## ネイティブprimitive

- `<span>` (インラインの状態表示)
- `<output>` (計算結果の出力として意味を持つ場合)

非インタラクティブな状態表示であり、`role` による再実装はしない。

## Required markup

```html
<span class="nv-badge">Neutral</span>
<span class="nv-badge nv-badge-primary">Primary</span>
```

## Nativum classes

このSkillの references/ に記載されたもののみ:

- `nv-badge` — 基本のbadge (subtle背景 + ボーダー + 角丸)
- `nv-badge-primary` / `nv-badge-success` / `nv-badge-warning` / `nv-badge-danger` — ソリッド背景 + `--nv-color-on-*` の文字色

variantはソリッドな背景色と `--nv-color-on-*` の文字色を組み合わせ、light / dark 双方で WCAG AA (4.5:1) を保証する。

```html
<span class="nv-badge nv-badge-success">Ready</span>
<span class="nv-badge nv-badge-danger">Unsupported</span>
```

## 動作 (ネイティブのinteraction)

- badge自体にinteractionはない (クリック・フォーカス不要の状態表示)

## フォールバック

- 背景色・ボーダー・角丸のみ。CSSなしでもテキストは表示される

## Anti-patterns

- 色だけで状態を伝える (テキストを必ず併記する)
- badgeをボタン・リンクとして使う (`<button>` / `<a>` を使う)
- 状態表示をボタンの装飾として独自に増やす (`nv-badge` を使う)
- variantクラスを発明する (`nv-badge-neutral` 等は存在しない)

## 詳細

この Skill 内の該当 section が正本。
