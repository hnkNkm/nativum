# Button

## 目的

ネイティブの `<button>` (および button型 `<input>`) にNativum標準スタイルを適用する。動作はブラウザのネイティブ実装に任せ、再実装しない。

## ネイティブprimitive

- `<button>`
- `<input type="submit">` / `<input type="reset">` / `<input type="button">`
- `disabled` 属性
- フォーム検証と送信 (`type="submit"`)

## Required markup

クラスなしで基本スタイルが適用される。

```html
<button type="button">Cancel</button>
<button type="submit">Submit</button>
<button disabled>Disabled</button>
```

## Nativum classes

このSkillの references/ に記載されたもののみ:

- `nv-primary` — 主要アクションの強調
- `nv-danger` — 破壊的操作 (削除等) の警告色

クラスは `<button>` / button型 `<input>` セレクタが対象。`<a>` には適用されない。

```html
<button class="nv-primary">Save</button>
<button class="nv-danger">Delete</button>
```

## 動作 (ネイティブのinteraction)

- クリック / Enter / Space で発火
- フォーム内 `type="submit"` はネイティブ検証後に送信
- `disabled` で操作不可 (opacity低下)
- `:focus-visible` でフォーカスリング

## フォールバック

高度なCSSを必要としない。CSSなしでも `<button>` はそのまま動作する。

## Anti-patterns

- `<div role="button" tabindex="0">` による再実装
- `<a>` をボタン風にスタイルして使う (`<a>` はナビゲーション専用)
- 非活性化に `aria-disabled` だけを使う (`disabled` 属性を使う)

## 詳細

この Skill 内の該当 section が正本。
