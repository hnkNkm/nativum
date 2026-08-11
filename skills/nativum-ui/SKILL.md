---
name: nativum-ui
description: Build and modify web interfaces using Nativum's native HTML and CSS patterns. Nativum Core is HTML+CSS only, but host application JavaScript (React, Vue, etc.) is allowed.
---

# Nativum UI Agent Skill

Nativum (Nativum Native Web UI System) の公式Agent Skillです。HTMLとCSSでモダンWeb UIを正しく構築・変更するための手順を定義します。Nativumは **Passive Native Web UI System** であり、JavaScriptを禁止するframeworkではありません。

## Nativum とは

- **Passive UI System** — 能動的なロジックを持たず、ブラウザのネイティブ動作とCSSの宣言的機能にUI挙動を委ねる
- **Nativum Core = HTML + CSS only** — 自身はJS/TS runtimeを持たない
- **zero third-party runtime dependencies / zero transitive runtime dependencies** — Nativumの下に第三者の実行可能な依存グラフを作らない
- **HTMLがComponent API** — JavaScript APIやComponent Object Modelは存在しない
- ブラウザが持つWeb Platform機能 (semantic HTML、`<details>`、`<dialog>`、Popover API、`command` / `commandfor`、CSS Grid / Flexbox、Container Queries、CSS Anchor Positioning など) をUIの基盤とする
- **Use the platform. Do not reimplement it.**

## バージョン

```text
Nativum 0.1.0
├── nativum.css       0.1.0
└── nativum-ui Skill  0.1.0
```

CSSとSkillは**同一バージョン**でリリースされます。このSkillが参照するAPIはNativum 0.1.0のものだけです。異なるバージョンのドキュメントや例を参考にしてクラス名やトークンを推測しないこと。

## 実装時の Decision Process

UIを実装・変更するときは以下の順序で判断する。

```text
1. Identify required interaction
        ↓
2. Search for semantic HTML primitive
        ↓
3. Check Nativum component reference
        ↓
4. Use native HTML behavior
        ↓
5. Add Nativum styling
        ↓
6. Add progressive CSS enhancement
        ↓
7. Verify fallback
```

1. **Identify required interaction** — 必要な操作を特定する
2. **Search for semantic HTML primitive** — `<button>`、`<input>`、`<select>`、`<details>`、`<dialog>`、`[popover]`、`command` / `commandfor` など、ブラウザが既に持つネイティブ機能を探す
3. **Check Nativum component reference** — 該当するcomponent reference (下記「参照ファイル」) を読み、公式のmarkupとクラスを確認する
4. **Use native HTML behavior** — 見つかったprimitiveの標準動作 (フォーカス、キーボード、検証、状態) をそのまま使う
5. **Add Nativum styling** — `references/` に**実在する**クラス・CSS変数のみを追加する
6. **Add progressive CSS enhancement** — 高度なCSS (Anchor Positioning、transition等) で強化する。`@supports` / `prefers-reduced-motion` 等で未対応環境を考慮する
7. **Verify fallback** — 高度な機能が利用不能でもコンテンツと基本操作が維持されることを確認する

### primitiveが見つからない場合 — STOP

```text
STOP
↓
Do not invent CSS hacks
↓
Explain that Nativum does not provide this behavior
```

該当するWeb Platform primitiveが存在しない場合、CSS hackで実現してはならない。Tabs等のUnsupported一覧は references/anti-patterns.md を確認し、「Nativumはこの動作を提供しない」ことを明示して実装しない。

## 参照ファイル

パスはこの Skill ディレクトリ (`skills/nativum-ui/`) からの相対。

| ファイル | 読むタイミング |
|---|---|
| `references/principles.md` | 実装を始める前。Nativumの4原則の行動指針 |
| `references/security.md` | HTML/CSSを生成した後。Security Contractの確認 |
| `references/compatibility.md` | 高度なCSS機能を使う判断をしたとき。Core / Enhancement / Experimentalの分類 |
| `references/anti-patterns.md` | 実装がUnsupported componentに該当しないか疑わしいとき。negative specification |
| `references/components/*.md` | 個別コンポーネントの公式markup・クラス・フォールバックを確認するとき |
| `references/patterns/*.md` | ページ全体の組み立て方 (settings / login / dashboard / server actions) を確認するとき |
| `examples/*.html` | コンポーネントの正しい組み合わせ方・reference implementationを確認するとき |

このSkillをアプリケーションへ vendor した場合、リポジトリ内の `docs/` と `src/` は存在しない。
クラス名・CSS変数の真実源はこの Skill 内の `references/` のみとし、存在しないAPIは推測して生成しない。

## Hard Rules

### MUST

- semantic HTMLを優先する
- native HTML behaviorを優先する
- documented Nativum APIのみ使用する
- browser primitiveが存在するならそれを使う
- Nativum自身へJavaScript runtimeを追加しない
- progressive enhancementを利用する
- accessibilityを維持する
- unsupported UIをCSS hackで無理に再現しない

### MUST NOT — Nativumの実装として

以下は**Nativum componentの実装として**追加してはならない。

- JavaScript runtime / TypeScript runtime
- third-party runtime dependency
- animation library / positioning library
- native dialogの自作modalへの置き換え
- native buttonの `<div role="button">` への再実装
- checkbox/radio hackによる不足UIの再現
- remote asset dependency (CDN stylesheet / Web Font / Icon Font / `@import url("https://...")` 等)
- 存在しないNativum class/tokenの推測

### MAY — Host Application側として

以下はNativumの実装ではなく**ホストアプリケーションの責務**として許可される。

- 既存React / Vue / Svelte等のアプリ内でNativumクラスを利用する
- application-specific behaviorとしてJS/TSを使用する
- application側のstate management・routing・data fetchingを使用する
- Nativumが提供しない複雑なinteractionをhost application側で実装する

ただし、Nativum componentが標準HTMLだけで実現可能なのに、不必要にJS stateへ置き換えないこと。

```text
details → useStateで再実装しない
dialog → custom modal stateで再実装しない
popover → dropdown libraryを不必要に導入しない
```

## 存在しないAPIを推測しない (Anti-Hallucination)

- **クラス**: `references/` に記載されているクラスのみ使用する。`.nv-*` クラスはここに無ければ存在しない
- **CSS変数**: `references/` に記載されている `--nv-*` トークンのみ使用する
- **属性**: 各component reference とHTML Standardで定義された属性のみ使用する (`aria-current`、`aria-invalid`、`popover`、`popovertarget`、`command` / `commandfor` 等)
- **コンポーネント**: `references/` に無いコンポーネントは存在しない。Unsupported一覧は `references/anti-patterns.md`
- **要素の再実装**: `<button>` が使える箇所で `<div role="button">` を生成しない。`<dialog>` が使える箇所で自作モーダルを生成しない

必要なクラス・トークンが `references/` に見つからない場合、**推測して生成せずにSTOP**し、Nativumが提供しないことを明示する。

## 出力の確認

生成したHTML/CSSがSecurity Contractを満たしていることを確認する (`references/security.md`)。リポジトリでは `./tools/verify.sh` が機械検査する。
