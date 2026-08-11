# Server Actions

## Purpose

Nativum とサーバーの連携パターン。Nativum はサーバーサイドアーキテクチャを限定せず、**最終的に生成される HTML だけを要求する**。状態変更は通常の HTML form submission と navigation を第一候補とする。

```html
<form method="post" action="/settings">
```

Nativum はクライアント状態・データ取得層を持たない。fetch ラッパーや AJAX は存在せず、追加もされない。

## 基本原則

1. **表示**は通常のリンク（`<a href>`）による navigation
2. **状態変更**は `<form method="post" action="...">` による通常送信
3. サーバーは成功時リダイレクト、失敗時はエラーを焼き込んだ HTML を再レンダリング
4. ダイアログ等の開閉は `command` / `commandfor`（HTML Standard）で宣言的に行う
5. JavaScript は不要。サーバー側フレームワーク（Go / Rust / Python / Ruby / PHP / Java / C# / Elixir / Haskell / 静的HTML 等）は問わない

## パターン 1: dialog 内フォームの送信

`commandfor` で dialog を開き、中の `<form method="post">` を通常送信する。ダイアログの開閉とフォーム送信は独立している（開閉はブラウザ、送信はサーバー）。

```html
<button commandfor="create-project" command="show-modal">New project</button>

<dialog id="create-project">
  <header>
    <h2>New project</h2>
  </header>
  <form id="create-project-form" action="/projects" method="post">
    <div class="nv-field">
      <label for="p-name">Project name</label>
      <input id="p-name" name="name" type="text" required>
    </div>
    <div class="nv-field">
      <label for="p-owner">Owner</label>
      <select id="p-owner" name="owner">
        <option selected>Hanako Tanaka</option>
        <option>Taro Yamada</option>
      </select>
    </div>
  </form>
  <footer>
    <button commandfor="create-project" command="close">Cancel</button>
    <button class="nv-primary" type="submit" form="create-project-form">Create</button>
  </footer>
</dialog>
```

- フッターの送信ボタンは `form="create-project-form"` で dialog 内のフォームを参照する
- `command="show-modal"` の開閉はブラウザのネイティブ動作（フォーカストラップ・Escキャンセル込み）
- バリデーションはネイティブ（`required` 等）が送信前にブロックする

## パターン 2: サーバー側エラーの再レンダリング

POST が失敗した場合、サーバーはエラー状態を焼き込んだ HTML を返す。Nativum はこの HTML をそのまま表示するだけでよい。

- フィールド単位のエラー: `aria-invalid="true"` + `.nv-field-error` + `aria-describedby`
- フォーム全体のエラー: `.nv-notice nv-notice-danger` + `role="status"`

```html
<!-- サーバー再レンダリング後の /projects レスポンス (失敗時) -->
<dialog id="create-project" open>
  <header>
    <h2>New project</h2>
  </header>
  <form id="create-project-form" action="/projects" method="post">
    <div class="nv-notice nv-notice-danger" role="status">
      同名のプロジェクトが既に存在します。
    </div>

    <div class="nv-field">
      <label for="p-name">Project name</label>
      <input id="p-name" name="name" type="text" value="nativum"
             aria-invalid="true" aria-describedby="p-name-error" required>
      <span class="nv-field-error" id="p-name-error">この名前は使用できません。</span>
    </div>
  </form>
  <footer>
    <button commandfor="create-project" command="close">Cancel</button>
    <button class="nv-primary" type="submit" form="create-project-form">Create</button>
  </footer>
</dialog>
```

- `value` にサーバー側で保持していた入力値を再出力する（入力が消えない）
- `aria-invalid="true"` は `src/50-forms.css` の `[aria-invalid="true"]` セレクタで赤ボーダーになる
- エラーは `.nv-field-error` のテキストで伝える。色だけに依存しない

## パターン 3: 確認操作（破壊的アクション）

破壊的操作は確認 dialog を挟み、`action` を分けたフォームで送信する。`name="action" value="delete"` でサーバー側が操作を判定できる。

```html
<button class="nv-danger" commandfor="delete-project" command="show-modal">
  Delete project
</button>

<dialog id="delete-project">
  <header>
    <h2>Delete project?</h2>
  </header>
  <p>この操作は取り消せません。プロジェクトと全データが削除されます。</p>
  <footer>
    <button commandfor="delete-project" command="close">Cancel</button>
    <button class="nv-danger" type="submit" form="delete-project-form"
            name="action" value="delete">Delete</button>
  </footer>
</dialog>
<form id="delete-project-form" method="post" action="/projects/nativum" hidden></form>
```

## フォールバック

- `commandfor` 未対応環境では、dialog を `open` 属性付きでサーバーレンダリングし、操作対象をページ内の通常フォームへ置き換える（`docs/components/dialog.md` の Fallback behavior）。フォーム自体はどの環境でも送信できる
- すべて標準HTMLのため、CSS・JavaScript の有無に関わらず送信は成立する

## アンチパターン

- 状態変更に `fetch()` / XMLHttpRequest / WebSocket を使い、エラーを JSON で返す（HTML form submission を使う）
- ダイアログの開閉をJavaScriptで行う（`command` / `commandfor` を使う。ホストアプリケーション側の実装は禁止しないが、ネイティブprimitiveを不必要にJS stateへ置き換えない）
- サーバーエラーを「ページの状態」として隠し持つ設計にする（エラーは HTML に焼き込んで再レンダリングする）
- フォーム送信後に JavaScript で成功表示や toast を出す（navigation / 再レンダリングで状態を伝える。クライアント状態の toast は対象外）

補足: htmx 等のクライアントスクリプトの導入はホストアプリケーションの判断であり、Nativumは禁止しない。ただしそれはNativum componentの実装ではなくホスト側のapplication-specific behaviorであり、Nativumが要求するのは最終的に生成されるHTMLだけである。
