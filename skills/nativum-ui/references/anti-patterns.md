# Unsupported Components & Anti-patterns — Negative Specification

NativumのUnsupported Components一覧と禁止パターン。Agentは「利用可能な機能」だけでなく「**利用不可能な機能**」も理解し、実装依頼があった場合はnegative specificationに従って実装せず理由を説明する。

**適用範囲**: 以下はすべて **Nativum componentの実装として**禁止されるものである。ホストアプリケーションが自前のJavaScriptで同種のUIを実装すること自体は禁止しない。ただしその場合も、Nativumの提供するネイティブprimitiveを不必要に自作で置き換えないこと。

## CSS checkbox hack / radio hack は常に禁止

Web Platformが提供しない状態管理を、checkbox / radioの `:checked` 状態で模倣することは**あらゆるUIで禁止**する。

理由:

- form controlを状態管理装置として悪用し、正しいHTML semanticsを壊す
- キーボード操作・スクリーンリーダー通知が不完全になり、アクセシビリティを大きく損なう

例: hidden radioでタブを切り替える、checkboxでモーダルやpopoverを再現する、`<label>` + `:checked` で開閉を再現する — すべて禁止。

## Unsupported Components

v0.1では原則として以下を対象外とする。各項目は `Status: Unsupported / Reason: / Do not:` 形式のnegative specificationである。

### Tabs (complex Tabs)

```
Status: Unsupported

Reason:
No Nativum-approved native semantic implementation currently exists.
(タブを意味的・アクセシブルに表現するWeb Platform primitiveが存在しない)

Do not:
- use hidden radio inputs
- use checkbox state hacks
- misuse <details>
```

補足: `<details>` は開閉式セクションでありタブではない。ナビゲーションリンクの見た目で「タブを実装した」ことにしない。リンクベースのページ遷移で代替する。

### Combobox with filtering

```
Status: Unsupported
Reason: 入力候補のフィルタリングにはクライアント状態が必要
Do not: text input + 自作ドロップダウンの組み合わせで再現する。ネイティブの <select> / <input> を使う
```

### Autocomplete

```
Status: Unsupported
Reason: 候補のフィルタリングとキーボード操作にJSが必要
Do not: JSなしでは成立しない。必要ならサーバー側の解決策 (通常フォーム・navigation) を検討する
```

### Virtualized List

```
Status: Unsupported
Reason: 描画の動的管理にJSが必要
Do not: ページネーション (nv-pagination + サーバー側分割) で代替する
```

### Data Grid / Spreadsheet

```
Status: Unsupported
Reason: セル編集・ソート・複雑な操作にJSが必要
Do not: 表示用途はセマンティックな <table> で行う。ソートはサーバー側で行う
```

### Drag & Drop application UI

```
Status: Unsupported
Reason: ドラッグ操作の状態管理にJSが必要
Do not: 代替として通常のフォーム送信・リンクによる操作フローを提供する
```

### Rich Text Editor

```
Status: Unsupported
Reason: contenteditable の挙動管理にJSが必要
Do not: <textarea> を使う
```

### client-state Toast queue

```
Status: Unsupported
Reason: キュー管理と表示・非表示の制御にJSが必要
Do not: 持続的なメッセージは nv-notice で表示する。popoverはlight dismissで閉じるため重要な状態表示に使わない
```

### command palette

```
Status: Unsupported
Reason: 検索・フィルタ・キーボードナビゲーションにJSが必要
Do not: ページ内の通常フォームとリンクで代替する
```

### complex Tree View

```
Status: Unsupported
Reason: 展開状態の管理にJSが必要
Do not: 複数階層の開閉は <details> の入れ子で表現できる範囲に留め、超える場合は実装しない
```

### SPA navigation

```
Status: Unsupported (Nativum Coreとしては)

Reason: Nativum Coreはクライアント側ルーティングを提供しない
Do not: Nativumの実装としてルーターを追加する。通常の <a href> リンクと
       サーバー側ページ遷移を基本とする

Host Applicationの範囲: ホストアプリケーションが自前のルーター (React Router等) を
使うことは禁止しない。Nativumは「HTMLを生成する」ことだけを要求する
```

### sortable / reorderable UI

```
Status: Unsupported
Reason: 並べ替え状態の管理にJSが必要
Do not: 表示順はサーバー側で決定して <table> / リストでレンダリングする
```

## その他の禁止パターン

- `<details>` をタブUIの代用に使う (`docs/components/details.md` Anti-patterns)
- `<div role="button" tabindex="0">` でボタンを再実装する
- `<div role="dialog">` + `aria-modal` でモーダルを自作する
- `position: fixed` + 自作クリック検知JSでオーバーレイ・dropdownを再実装する
- popover内のリンクリストに `role="menu"` を付ける (Arrow key等のフルキーボード操作の実装が前提になる。JSなしでは成立しない。リンクリストはそのまま `<a>` のリストでよい)
- popoverトリガーに `aria-expanded` を付ける (popoverトリガーでは利用不可)
- 複数のdropdownに同じ `--nv-anchor` 名を使う (アンカー名はページ内で一意に)

## 依頼への対応手順

UnsupportedなUIの実装を依頼された場合:

1. **実装しない** (CSS hack・JSで無理に再現しない)
2. 上記のnegative specification形式で「Status: Unsupported」であることを明示する
3. 理由を説明する (適切なWeb Platform primitive / Nativum実装が存在しない)
4. 可能ならサポート済みの代替案 (サーバー側での解決、`nv-notice` / `nv-pagination` / `<details>` 等) を提示する
