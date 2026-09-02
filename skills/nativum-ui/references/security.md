# Security Contract — Agent向け

Nativum CoreのSecurity Contract。Agentが生成するHTML/CSSは常に以下を満たすこと。

```text
Nativum Core Security Contract

JavaScript runtime dependencies        0
TypeScript runtime dependencies        0
Third-party runtime dependencies       0
Transitive runtime dependencies        0
Executable install hooks               0
Remote runtime assets                  0
Telemetry                              0

Nativum Core implementation:
HTML + CSS only
```

> **No executable UI runtime and no implicit remote runtime resources.**

これは**Nativum Coreの実行時依存グラフ**についての契約であり、ホストアプリケーションのJavaScript (React / Vue / Svelte等) や開発環境のNix等は禁止対象ではない。

## Nativum Coreの実装に含めてはならないもの

```text
*.js
*.jsx
*.ts
*.tsx

node_modules/
package-lock.json / pnpm-lock.yaml / yarn.lock

vite.config.* / webpack.config.* / postcss.config.*
```

package.json自体はnpm配布metadataとして許容される。ただし存在する場合は:

```text
dependencies / optionalDependencies / peerDependencies が空
preinstall / install / postinstall / prepare 等の install hook なし
main は nativum.css (runtime JavaScript entry なし)
```

## Remote依存の禁止

以下のようなremote依存をCSS・HTMLに含めてはならない。

```css
@import url("https://...");
```

```css
background-image: url("https://...");
```

- 外部Web Font、外部Icon Font、CDN stylesheetは使用しない
- 標準テーマはOS/system font stackのみを使用する (このSkillの `references/` に記載の `--nv-font-sans` / `--nv-font-mono`)
- `--nv-select-icon` は**データURI** (`data:image/svg+xml`) であり外部依存ではない。これは禁止対象に含まれない
- アイコンが必要な場合も同様に、外部Icon FontやCDN画像ではなくデータURIまたはCSS描画で対応する

## Agentが生成するHTML/CSSに含めてはいけないもの

- `<script>` タグ (インライン・外部とも)
- `onclick` / `onload` 等のインラインイベントハンドラ属性
- `<link rel="stylesheet" href="https://...">` 等のCDN参照
- JSフレームワーク・ライブラリをNativum componentの実装として読み込むための要素
- `<div role="button" tabindex="0">` 等のネイティブ要素の再実装
- `<div role="dialog">` 等による自作モーダル

## verify.sh

リポジトリの `./tools/verify.sh` がexecutable supply-chain attack surfaceを機械検査する。Agentが生成したHTML/CSSがNativumプロジェクトに含まれる場合は、必ずこの検査を通過できること。

実行方法:

```sh
./tools/verify.sh
```

検査内容 (静的解析。実行時にネットワークが無いことの証明ではない):

1. コミット済み `dist/` が `src/` と一致すること — 一時ディレクトリへ `build.sh` して `cmp` する。`dist/` は書き込まない (自動上書きしない)
2. JS/TS runtime file (`*.js` `*.jsx` `*.ts` `*.tsx` `*.mjs` `*.cjs` `*.mts` `*.cts`、大小文字無視) が存在しない (`.git` / `.direnv` / `.opencode` は除外)
3. `node_modules/`・lockファイルが存在しない
4. Node build config (`vite.config.*` 等) が存在しない
5. package.jsonが存在する場合、passive artifact metadataであること (空dependencies / install hookなし)
6. CSSの remote `@import` / `url()` (`http(s)://` および `//host`。`data:` URI は除外対象ではなく、パターンが `url(` 直後のプロトコルだけを見る)
7. `examples/` と `skills/` の HTML に `<script>` / `<style>` が存在しない
8. 同 HTML に `onclick` / `onload` 等のインラインイベントハンドラ (`on[a-z]+="` / `on[a-z]+='`) と `javascript:` URL が存在しない
9. 同 HTML の form `action` / button `formaction` に `https?://` または `//host` が存在しない (相対パスや `action="#"` は許可)
10. 同 HTML のランタイム資源タグ (script/link/img/iframe 等) に remote / protocol-relative の src/href 等が存在しない。通常の `<a href="https://...">` は対象外
11. 同 HTML に `role="button"` / `role='button'` の div / span 再実装が存在しない
12. 外部Web Font / 外部Icon Font が存在しない

`VERIFY OK` は上記の静的検査を通過したことであり、Security Contract 全体や実行時の非通信を証明しない。失敗した場合は出力される `VERIFY FAIL: ...` の内容に従って修正する。

## 生成物の確認手順

1. HTMLを書き終えたら `<script>`・イベントハンドラ属性・CDN参照が無いことを確認する
2. `@import` / `url(...)` に `https://` が無いことを確認する
3. 使用したクラス・CSS変数が Nativum Skill の `references/` に実在することを確認する
4. 可能なら `./tools/verify.sh` を実行する
