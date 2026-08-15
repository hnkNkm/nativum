# Layout

## 目的

頻出レイアウト (縦積み・横並び・グリッド・コンテンツ幅) を少数のlayout primitiveで提供する。utility framework化はしない。

## ネイティブprimitive

- 任意のコンテナ要素 (`<div>` / `<section>` / `<article>` / `<header>` / `<footer>` / `<main>`)
- CSS Flexbox (`display: flex`)
- CSS Grid (`display: grid`)
- CSSカスタムプロパティ `--nv-grid-min` (グリッドの最小列幅)

レイアウト専用のHTML要素は存在しない。文書構造に基づいて要素を選ぶ。

## Required markup

`nv-stack` / `nv-stack-sm` / `nv-stack-lg` は単独で縦スタックを作る (`display: flex; flex-direction: column` + `gap`)。

```html
<div class="nv-stack">...</div>
<div class="nv-stack-sm">...</div>
<div class="nv-stack-lg">...</div>

<div class="nv-cluster">
  <button>Cancel</button>
  <button>Save</button>
</div>

<div class="nv-grid">...</div>

<main class="nv-container-narrow">...</main>
```

## Nativum classes

このSkillの references/ に記載されたもののみ:

- `nv-stack` — 縦flex (`gap: var(--nv-space-4)`)
- `nv-stack-sm` — 単独で縦スタック (`gap: var(--nv-space-2)`)
- `nv-stack-lg` — 単独で縦スタック (`gap: var(--nv-space-6)`)
- `nv-cluster` — 横flex + 折り返し (`align-items: center`)
- `nv-cluster-between` — `justify-content: space-between` のみの修飾。`.nv-cluster` と併用
- `nv-cluster-end` — `justify-content: flex-end` のみの修飾。`.nv-cluster` と併用
- `nv-grid` — 最小列幅ベースのグリッド (`--nv-grid-min` を上書きして列幅を変更)
- `nv-container` — 本文幅 (`--nv-content-width: 64rem`)
- `nv-container-narrow` — 狭幅 (`--nv-narrow-width: 40rem`)

```html
<div class="nv-cluster nv-cluster-between">
  <strong>Title</strong>
  <button>Action</button>
</div>

<div class="nv-grid" style="--nv-grid-min: 22rem">...</div>
```

## 動作 (ネイティブのinteraction)

- レイアウト固有のinteractionはない。子要素のネイティブ動作がそのまま機能する
- Cluster の折り返し・Grid の列数はコンテナ幅に応じてCSSが自動調整する
- フォーカス順・タブ順は変更しない

## フォールバック

- Flexbox / Grid のみ。CSSなしでは通常のブロックフローで縦に並ぶ
- `--nv-grid-min` 未設定でもデフォルト (`16rem`) でグリッドが機能する

## Anti-patterns

- layout primitiveをutility frameworkとして扱う (任意のmargin / padding / 幅を `nv-*` で表現)
- `nv-cluster-between` / `nv-cluster-end` を単独で使う (`.nv-cluster` と併用する)
- `nv-stack-sm` / `nv-stack-lg` を `nv-stack` との併用必須と誤解する (各クラスは単独で縦スタックを作る)
- グリッドの列数を固定値で指定する (`--nv-grid-min` で管理する)
- レイアウトのために `role` やセマンティック要素を流用する

## 詳細

この Skill 内の該当 section が正本。リポジトリの `docs/components/` は人間向けの詳細版。
