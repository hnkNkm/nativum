# Nativum

**Modern UI, by the Web Platform.**

A passive, zero-JavaScript UI system built directly on modern HTML and CSS.

> Nativum adds no executable UI runtime, no third-party runtime dependencies, and no transitive dependency chain.
>
> **HTML is the component API. The browser is the UI runtime.**

NativumはJavaScript / TypeScriptエコシステムに依存せず、現代のHTML / CSS / Web Platformが標準で提供する機能を最大限活用してWeb UIを構築するための **Passive Native Web UI System** です。

Nativum自身はJavaScriptを実行しません。**HTMLそのものがComponent API**であり、UIのランタイムはブラウザです。

## Nativumとは

```text
Host Application
        │
        ▼
 Semantic HTML
        │
        ▼
     Nativum        (HTML規約 + CSS設計システム + ネイティブUIパターン)
        │
        ▼
     Browser        (UI Runtime)
```

Nativumの責務は `appearance / typography / spacing / layout / responsive design / native interaction styling / CSS motion` であり、`application logic / state / routing / data fetching / DOM orchestration` はホストアプリケーションの責務です。

## 思想 (Philosophy)

**Use the platform. Do not reimplement it.**

- **Native semantics over feature count** — Web Platformで意味的・アクセシブルに実装できないUIは提供しない (CSS hackで再現しない)
- **Security by absence** — Nativum Coreの下に第三者の実行可能な依存グラフを作らない
- **No executable UI runtime** — CoreはHTML+CSSのみ。JS/TS runtime・install hook・remote runtime asset・telemetryはゼロ
- **Distribution is a transport concern, not a runtime dependency** — 配布方法は問わない (npm等のpackage metadataも空のdependenciesでpassive)
- **JavaScriptを禁止しない** — ホストアプリケーションがReact等を使うことは自由。NativumはJavaScriptを「要求しない」だけ

## 導入

Release済みの `nativum.css` を読み込むだけです。

```html
<link rel="stylesheet" href="/vendor/nativum/nativum.css">
```

配布方法は制限しません (Git clone / vendoring / GitHub Releases / npm / JSR / Cargo / CDN など、自由)。どの配布形式でもNativum CoreはHTML+CSSのみで、実行時依存は存在しません。npm package等で配布する場合も、中身はpassive artifactのみ (空のdependencies、install hookなし) とします。

## ブラウザサポート

Nativum CoreのCSS primitive（Cascade Layers、`:focus-visible`、`color-scheme`、CSS Grid / Flexbox、CSS Custom Properties）は、2022年以降のモダンブラウザ（Chrome / Edge / Firefox / Safari の最新2世代程度）を前提としています。

機能は Core / Enhancement / Experimental の3段階に分類され、各機能のフォールバックは [docs/browser-policy.md](docs/browser-policy.md) にまとめています。

- `command` / `commandfor`（Invoker Commands）は **Enhancement** である。Baseline Newly Available（2025-12-12、Chrome 135 / Firefox 144 / Safari 26.2）で、上記 Core CSS baseline より新しい
- Dialog の Core は `<dialog>` / `<dialog open>`。Invoker Commands 非対応環境では `<dialog open>` + ページ内フォームがそのまま使える（[examples/dialog.html](examples/dialog.html) のフォールバック節、[docs/components/dialog.md](docs/components/dialog.md)）
- JS runtime は追加しない（フォールバックもサーバーレンダリング + HTML / CSS の範囲）

## 例

```html
<!-- dialog: ネイティブの command / commandfor で宣言的に操作する -->
<button commandfor="settings" command="show-modal">Settings</button>

<dialog id="settings">
  <header><h2>Settings</h2></header>
  <form id="settings-form">
    <label for="name">Name</label>
    <input id="name" name="name" type="text" required>
  </form>
  <footer>
    <button commandfor="settings" command="close">Close</button>
    <button class="nv-primary" type="submit" form="settings-form">Save</button>
  </footer>
</dialog>
```

> **注意**: この例の `command` / `commandfor` は Invoker Commands 対応ブラウザ（Chrome 135 / Firefox 144 / Safari 26.2 以降）でのみ動作します。非対応環境では `<dialog open>` のサーバーレンダリング + ページ内フォームにフォールバックしてください（「ブラウザサポート」参照）。

## Host Applicationから利用する

Nativumは「JavaScriptを禁止する」のではなく「JavaScriptを**要求しない**」UIシステムです。以下すべてから利用できます。

```text
plain HTML / React / Vue / Svelte / Solid / Astro / Hono JSX
Rails / Django / Phoenix / ASP.NET / Go templates / Rust templates
```

```tsx
<button className="nv-primary">Save</button>
```

Reactアプリケーションに追加しても、Nativum自身が新たなUI runtime dependencyを追加するわけではありません。

## 開発

```sh
# 開発環境 (flake)
nix develop

# ビルド (POSIX shell + 標準Unix toolのみ)
./tools/build.sh          # → dist/nativum.css + dist/SHA256SUMS

# セキュリティ検証 (executable supply-chain attack surface の検査)
./tools/verify.sh

# 例ページの表示
./tools/serve.sh          # → http://localhost:8080/examples/
```

## AI Agent

NativumはAI coding agentを正式な利用者として扱います。公式Agent Skill `nativum-ui` を `skills/` に提供しています。

```sh
cp -r skills/nativum-ui ~/.config/opencode/skills/  # 例: opencode
```

## 構成

```text
src/        ソースCSS (Cascade Layersで構成)
dist/       ビルド済み nativum.css
examples/   デモアプリ (HTML + nativum.css のみ)
docs/       component / pattern ドキュメント
skills/     公式Agent Skill (nativum-ui)
tools/      build.sh / verify.sh / serve.sh
```

## セキュリティ

Nativum CoreのSecurity Contractは「実行時に第三者の実行可能な依存グラフを持たない」ことです。詳細は [docs/SECURITY.md](docs/SECURITY.md) を参照してください。

- CoreはHTML+CSSのみ。JS/TS runtime・install hook・remote runtime asset・telemetryはゼロ
- 契約の充足は `./tools/verify.sh` で機械検査できます
- 脆弱性はpublic issueで報告せず、リポジトリの **Private Vulnerability Reporting** (Securityタブ → Report a vulnerability) から報告してください

## ライセンス

MIT — `LICENSE` を参照。
