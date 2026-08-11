# Security Policy

## 基本方針: Passive Security

Nativumは **Passive Native Web UI System** であり、実行時セキュリティを「監査」ではなく「**含まないこと**」で成立させる。

> **No executable UI runtime and no implicit remote runtime resources.**

## Nativum Core Security Contract

Nativum Coreは以下を保証する。

| 項目 | 保証 |
|---|---|
| JavaScript runtime dependencies | 0 |
| TypeScript runtime dependencies | 0 |
| Third-party runtime dependencies | 0 |
| Transitive runtime dependencies | 0 |
| Executable install hooks | 0 |
| Remote runtime assets | 0 |
| Telemetry | 0 |

```text
Nativum Core implementation:
HTML + CSS only
```

この契約は**Nativum Coreの実行時依存グラフ**についてのものであり、開発環境のNix / nixpkgs / flake-utilsや、ホストアプリケーション自身の技術スタック (React等) を対象に含めない。

「zero-dependency」という表現は、`zero third-party runtime dependencies` や `zero transitive runtime dependencies` のように対象を明確にして使用する。

## CSSも無害ではない

「JavaScriptがないから絶対安全」という表現は誤り。CSSにも外部通信につながる仕組みが存在する。

```text
@import
url()
@font-face
remote resource loading
```

Nativum Coreでは以下を禁止する。

```text
remote @import
remote url()
remote Web Font
remote Icon Font
remote images
remote stylesheets
implicit network resource loading
```

data URIによるNativum自身に埋め込まれた静的asset (例: `<select>` の矢印アイコン) は許容する。

## 配布物への制約

Nativumをnpm等のpackage managerで配布する場合も、中身はpassive artifactのみとする。

- `dependencies` / `optionalDependencies` / `peerDependencies` は空
- install lifecycle script (`preinstall` / `install` / `postinstall` / `prepare` 等) なし
- binary downloader / remote code downloader / native addon / telemetry なし
- runtime JavaScript なし

package managerは配送手段であり、実行時アーキテクチャではない。

## 自動検査

```sh
./tools/verify.sh
```

は、executable supply-chain attack surfaceの検出を目的とし、以下を機械検査する。

```text
JS/TS runtime files
<script> in official examples (examples/ と skills/ の全HTML)
remote resource attributes in official HTML (src/href/data/srcset/poster 属性と
inline style の url() による http(s):// 参照)
remote CSS imports / fonts / url()
node_modules / package manager lock files
install hooks / third-party dependencies (package.json がある場合)
div + role="button" によるネイティブ要素の再実装
コミット済み dist/nativum.css と src/ の整合性 (dist drift)
dist/SHA256SUMS の整合性
```

**制約の正直な範囲**: このスクリプトはNativum Coreと公式exampleの静的解析であり、「実行時に全く通信しない」ことの証明ではない。検査は `src/` / `examples/` / `skills/` の静的成果物に対するもので、`tools/verify.sh` 自体の実行環境（POSIX shell等）の健全性は対象外である。

CIでは以下を実行する:

```sh
./tools/build.sh
git diff --exit-code -- dist/
./tools/verify.sh
```

## 脆弱性報告

**Security vulnerabilities must not be reported through public issues.**

脆弱性はGitHubの **Private Vulnerability Reporting** (Security Advisories) を通じて報告してください。

1. リポジトリの **Security** タブ → **Report a vulnerability**
2. 影響を受けるバージョンを明記
3. 問題の再現方法を記載
4. 推奨される対処 (あれば)

報告から対応までの時間の保証はv0.1のプレリリース段階では定めないが、対応後はSecurity Advisoryとして公開する。
