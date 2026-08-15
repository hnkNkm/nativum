# Browser Capability Policy

## Purpose

3段階分類（Core / Enhancement / Experimental）を、`src/` 配下の実装に基づいて具体的に示す。Nativum は JavaScript UI Runtime を持たないため、以下の依存関係はすべて HTML / CSS レベルで完結する。

各機能について「使われている場所（`src/` のファイル名）」と「利用できない場合のフォールバック」を明記する。

## 分類の定義

| 分類 | 定義 |
|---|---|
| Core | その機能なしでは component が成立しない Web Platform primitive |
| Enhancement | 利用可能なら UI・positioning・motion を改善するが、なくても利用可能 |
| Experimental | 仕様または実装が十分成熟していない機能。明示的 opt-in のみ |

## Core

Core は「その機能なしでは component が成立しない」層である。`src/` のすべてのルールはこれらに依存して構成される。

| Web Platform 機能 | 使われている場所 | ない場合のフォールバック |
|---|---|---|
| `<dialog>` / `<dialog open>` + `::backdrop` | `src/60-components.css`（`dialog` / `dialog::backdrop` / `dialog > header` / `dialog > footer`） | `command` / `commandfor` 未対応環境では `<dialog open>` 属性付きでサーバーレンダリングし、操作対象をページ内のフォームへ置き換える（`docs/components/dialog.md` の Fallback behavior）。カスタムモーダルによる再実装は禁止 |
| `command` / `commandfor`（`show-modal` / `close` 等） | CSS には登場しないHTML属性。`src/60-components.css` の dialog スタイルと `examples/dialog.html` / `examples/dashboard.html` で使用 | 上記のとおり `<dialog open>` のサーバーレンダリング + ページ内フォームへフォールバック |
| Popover API（`[popover]` / `popovertarget` / `:popover-open`） | `src/60-components.css`（`[popover]` ブロック）、`src/70-motion.css`（`:popover-open` transition） | popover 非対応環境では `[popover]` 要素がドキュメントフロー内の通常コンテンツとして表示される。トリガーから内容が「永久に隠れる」設計にしない（`docs/components/dropdown.md` の Fallback behavior） |
| `<details>` / `<summary>` + `open` / `name` | `src/60-components.css`（`details` / `summary` / `.nv-accordion`）、`src/70-motion.css`（chevron の transition）。`name` はCSS不要のHTMLネイティブ排他グループ | `details[name]` の排他性が無い古い環境でも各 `<details>` は独立した disclosure として開閉できる。排他性のためにJavaScriptで再実装しない |
| Native form validation（`required` / `type` / `minlength` 等）と `:user-invalid` | `src/50-forms.css`（`:user-invalid` / `:user-invalid:focus-visible`） | 送信ブロックはブラウザのネイティブ動作。`:user-invalid` 未対応では赤ボーダーが付かないだけで検証自体は機能する。サーバー側検証エラーは `[aria-invalid="true"]` スタイル（同ファイル）で表現する |
| `color-scheme` | `src/20-tokens.css`（`:root { color-scheme: light dark; }`、`:root[data-theme="dark"]` / `[data-theme="light"]`） | 未対応環境では form control が UA 既定の配色のまま描画される。テキスト・背景は `--nv-color-*` トークンで管理されるため、コンテンツの可読性は維持される |
| CSS Custom Properties（Design Tokens） | `src/20-tokens.css`（全トークン定義）、`src/30/40/50/60/70-*.css` の各ファイルで `var()` 参照 | 未対応環境は現在ほぼ存在しない。トークンが取得できない場合、各要素は UA 既定値にフォールバックする |
| CSS Grid / Flexbox | `src/40-layout.css`（`.nv-stack` / `.nv-cluster` / `.nv-grid` / `.nv-container`） | `flex-wrap: wrap` と `repeat(auto-fit, minmax(min(100%, var(--nv-grid-min)), 1fr))` により、狭い環境でもフローが折り返されて維持される |
| CSS Cascade Layers（`@layer`） | `src/00-layer.css`（layer 順序の宣言）、全ファイルの `@layer` ブロック | `@layer` 非対応環境では `@layer` ルール全体が無視されるため Nativum スタイルが適用されない。2022年以降の全モダンブラウザで対応済みのため、実質的なリスクなし |
| `:focus-visible` | `src/30-base.css`（グローバルフォーカスリング） | フォーカスリングが描画されないだけ。ネイティブのフォーカス順序・キーボード操作は維持される |

Core CSS primitive は 2022年以降の全モダンブラウザで利用可能です。一方 `command` / `commandfor`（Invoker Commands）は Baseline Newly Available（2025-12-12、Chrome 135 / Firefox 144 / Safari 26.2）で、Core CSS baseline より新しい機能です。非対応環境では上記 Core 表のフォールバック（`<dialog open>` + ページ内フォーム）が必須です。

## Enhancement

Enhancement は「利用可能なら UI・positioning・motion を改善するが、なくても利用可能」な層である。motion系の機能は `@media (prefers-reduced-motion: no-preference)` 内でのみ有効になる（`src/70-motion.css`）。

| Web Platform 機能 | 使われている場所 | ない場合のフォールバック |
|---|---|---|
| `@starting-style` | `src/70-motion.css`（`dialog[open]` / `dialog[open]::backdrop` / `[popover]:popover-open` の enter アニメーション） | フェード・スケールなしの即時表示。表示と操作は維持される |
| `allow-discrete` transition（`display` / `overlay` プロパティ） | `src/70-motion.css`（基底 `dialog` / `dialog::backdrop` / `[popover]` に transition を置き、enter と exit の双方で適用） | トップレイヤーへの出入りはブラウザが制御する。transition は非対応プロパティを除いて縮退する |
| CSS Anchor Positioning（`anchor-name` / `position-anchor` / `anchor()`） | `src/60-components.css`（`@supports (anchor-name: ...) and (top: anchor(top))` ガード内の `.nv-dropdown-trigger` / `.nv-dropdown` / `.nv-dropdown-end`） | `@supports` によりこのルール群自体が無効化され、popover のデフォルト配置にフォールバックする（`docs/components/dropdown.md`） |
| Container Queries（`@container`） | **v0.1 の `src/` では未使用**。方針として「Nativum の responsive design は viewport だけでなく Container Queries を積極的に利用する」としているが、v0.1 では `.nv-grid` の `--nv-grid-min`（`minmax` + `auto-fit`）グリッドがコンテナ幅追従の役割を代替している | 使用していないためフォールバック不要。今後のバージョンで導入する場合は必ず Enhancement として扱う |
| `accent-color` | `src/50-forms.css`（`input[type="checkbox"]` / `input[type="radio"]` / `input[type="range"]` / `progress` / `meter`） | ブラウザ既定のアクセントカラーで描画される |
| `light-dark()` | `src/20-tokens.css`（全 `--nv-color-*` トークンの値） | 未対応環境ではカスタムプロパティの値が invalid-at-computed-value となり、各要素は UA 既定色へフォールバックする。`color-scheme` による form control の配色はそのまま機能する |
| `text-wrap: balance` / `text-wrap: pretty` | `src/30-base.css`（`h1`–`h6` / `p`） | 通常の折り返しにフォールバック |
| `dvh`（`max-height: 80dvh`） | `src/60-components.css`（`dialog`） | 宣言が無視され `max-height` 指定なし。`overflow: auto` により内容はスクロール可能 |
| `appearance: none`（select のカスタム矢印） | `src/50-forms.css`（`select`）+ `src/20-tokens.css`（`--nv-select-icon` データURI） | ネイティブの select 矢印が表示される。アイコンはデータURIで焼き込まれており外部依存はない |

## Experimental

明示的 opt-in のみ有効になる機能。Nativum Core は既定で有効にしない。

| Web Platform 機能 | 使われている場所 | ない場合のフォールバック |
|---|---|---|
| `@view-transition { navigation: auto; }` | Coreでは**無効**（`src/70-motion.css` のコメントに使用法を記載）。ホストアプリケーションが明示的に opt-in する | 記載しない限りページ遷移アニメーションは発生しない（通常ナビゲーション） |

補足: cross-document View Transitions は仕様・実装が成熟しつつあるものの、Nativumを読み込むだけでホストアプリケーションのナビゲーション挙動を変えないため、**明示的 opt-in のみ**に分類する。

## コンポーネント別の Required / Enhancement / Fallback

各コンポーネント文書には以下を要求する。`docs/components/*.md` に詳細がある。

| Component | Required primitives（Core） | Enhancement primitives | Fallback behavior の参照先 |
|---|---|---|---|
| Button | `<button>`、`:focus-visible` | transition（`src/70-motion.css`） | UA 既定のボタンとして機能 |
| Forms | ネイティブ form control、`:user-invalid`、`[aria-invalid="true"]` | `accent-color` 等 | CSS なしでも送信可能。`docs/components/forms.md` |
| Details / Accordion | `<details>` / `<summary>` / `open` / `name` | chevron の回転 transition | `details[name]` が無い古い環境でも独立disclosureとして開閉。`docs/components/details.md` |
| Dialog | `<dialog>`、`command` / `commandfor` | `@starting-style`、`allow-discrete`、`::backdrop` フェード | `<dialog open>` のサーバーレンダリング。`docs/components/dialog.md` |
| Popover | Popover API | `:popover-open` transition | フロー内コンテンツとして表示。`docs/components/popover.md` |
| Dropdown | Popover API | CSS Anchor Positioning（`@supports` ガード内） | popover のデフォルト配置。`docs/components/dropdown.md` |
| Navigation | `nav` / `a` / `ol` / `ul`、`aria-current="page"` | hover の背景変化 transition | 通常のリンクリスト。`docs/components/navigation.md` |
| Table | `table` / `thead` / `th` / `td` | `nv-table-striped` / row hover | 通常のテーブル。`docs/components/table.md` |

## Popover accessibility policy

- `popovertarget` のネイティブinvoker relationshipを利用し、独自 `aria-expanded` stateを手動同期しない
- Nativumの標準dropdownは通常のリンク / ボタンの集合でありARIA menu widgetではない
- role-lessな通常リンクリストpopupへ `aria-haspopup="true"` を付けない。ARIAでは `true` は `menu` と同義で、popup semanticsと一致しない

## 検証方針

- すべての motion は `@media (prefers-reduced-motion: no-preference)` 時のみ有効（`src/70-motion.css`）。`prefers-reduced-motion: reduce` では Nativum の duration トークンが実質ゼロ (0.01ms) になり、ホストアプリケーションのアニメーションには影響しない
- `examples/*.html` は JavaScript を無効化した状態で全機能を確認できる
