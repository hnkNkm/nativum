# Nativum の原則 — Agent向け行動指針

Nativumの原則を、実際にコードを書くときの判断基準に言い換えたもの。すべての実装判断の上位基準となる。

## 1. Native First — ブラウザが持っているものを使う

ブラウザに適切なネイティブ機能が存在する場合、必ずそれを使用する。

行動指針:

- ボタンが必要なら `<button>`。`<div role="button" tabindex="0">` で再実装しない
- モーダルが必要なら `<dialog>`。`position: fixed` の自作オーバーレイを作らない
- 開閉式セクションが必要なら `<details>` / `<summary>`
- 軽量オーバーレイが必要なら Popover API (`[popover]` + `popovertarget`)
- `<input>` / `<select>` / `<progress>` / `<meter>` など、意味と動作を持つ要素を優先する
- nativeで足りない視覚的要素だけをNativumの `nv-` クラスで整える

**注意**: `<div role="button">` の再実装はNativumのHard Rulesで明示的に禁止されている。ボタンが必要なら必ず `<button>` を生成すること。

## 2. Security by Absence — Nativumの下に実行可能な依存グラフを作らない

「依存関係を監査して安全にする」のではなく、**Nativum Coreの下に第三者の実行可能な依存グラフを存在させない**ことを基本戦略とする。

対象は**Nativum Coreの実行時依存グラフ**であり、ホストアプリケーションの技術スタック (React等) は禁止しない。

行動指針:

- Nativumの実装としてJS/TSを書かない。Nativumへnpm installしない
- CDN・外部フォント・外部リソースを参照しない
- 「ライブラリを入れる」ことでしか実現できない機能は、Nativumではその機能を提供しないと判断する
- 生成物は「ブラウザ + `nativum.css` だけで動く」状態を維持する (詳細は `security.md`)

## 3. Semantics over Features — 正しいsemanticsを機能の数より優先する

実現できるUIの数より、正しいHTML semanticsを優先する。

行動指針:

- タブUIを実現するためにradio buttonを状態管理装置として悪用するようなCSS hackをしない
- 適切なWeb Platform primitiveが存在しない場合、**Nativumではそのコンポーネントを提供しない** (STOP手順。`SKILL.md` / `anti-patterns.md` 参照)
- 「見た目が似ている」ことと「正しい実装である」ことは同義ではない
- 実装の難しさよりも、意味とアクセシビリティが正しいことを優先する

## 4. Progressive Enhancement without Script — scriptなしで段階的に強化する

高度なCSS機能が利用可能ならUIを強化するが、その機能が存在しなくても基本操作とコンテンツへのアクセスを維持する。

```text
Semantic HTML
    ↓
usable
    ↓
Nativum base CSS
    ↓
modern UI
    ↓
advanced CSS capabilities
    ↓
enhanced UI / motion
```

行動指針:

- enhancementは常に「基本構造の後付け」として書く。基本構造が先に成立していなければならない
- 未対応環境への配慮は `@supports` / `@media (prefers-reduced-motion)` 等でガードする
- motionが無くても操作・意味・状態を理解できる設計を維持する
- 高度なCSSが使えない環境で「コンテンツが隠れる」「操作不能になる」設計にしない (dropdown同様)

## 5. Passive UI System — Nativumは能動的なロジックを持たない

NativumはPassive UI Systemであり、`appearance / typography / spacing / layout / responsive design / native interaction styling / CSS motion / accessibility-friendly conventions` を提供する。`application logic / state / routing / data fetching / DOM orchestration` はホストアプリケーションの責務である。

行動指針:

- Nativum componentの実装としてJS runtime・animation library・positioning libraryを追加しない
- 標準HTMLだけで実現可能なものをJS stateへ置き換えない (`details` → `useState` 等)
- host application側のJavaScript (React / Vue / Svelte / Astro 等) は禁止しない。Nativumはその上でclassを適用してよい
- 「Nativum自身がJSを必要とする」ような生成物を作らない
