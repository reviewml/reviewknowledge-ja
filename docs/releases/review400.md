2019/10/29 by @kmuto

# Re:VIEW 4.0 での変更点

Re:VIEW 4.0 において 3 系から変更した点について解説します。

----

Re:VIEW は定期的に機能向上のためのリリースを続けていますが、2019年10月29日にメジャーバージョン改訂となる「[Re:VIEW 4.0.0](https://github.com/kmuto/review/releases/tag/v4.0.0)」をリリースしました。

バージョン 3.0 は2018年11月のリリース ([Re:VIEW 3 からの LaTeX 処理](../latex/review3-latex.html) を参照) で、マイナーリリースも 3.1, 3.2 だけだったので、だいぶ早いメジャーバージョン改訂です。

実のところ、表面的には、いくつか便利になった・バグが修正されたというくらいで、バージョン3からはそれほど大きな変化というものはありません。

しかし、このバージョンでは Re:VIEW の内部実装をかなり変更しており、review-ext.rb を使って Re:VIEW の挙動を変更・拡張していたプロジェクトには多大な影響が出る可能性が見込まれます。そのため、メジャーバージョンの改訂という形で、内部実装の大きな非互換があることを表すことにしました。

----

## 既知の問題
#### Re:VIEW 3 系のプロジェクトをそのまま利用しようとすると、`./__REVIEW_BOOK__.tex:79: LaTeX Error: Missing \begin{document}.` のようなエラーが発生する

後方互換性を提供するマクロに不備がありました ([#1414](https://github.com/kmuto/review/issues/1414))。

すべて更新してよければ、後述の `review-update` コマンドを使ってください。

既刊書などで 4.0 のマクロでの変化を避けたい場合には、以下の2行からなるマクロを `review-custom.sty` に追加してください。

```
\DeclareRobustCommand{\reviewincludegraphics}[2][]{%
  \includegraphics[#1]{#2}}
```

#### media=ebook を使うと、「! TeX capacity exceeded, sorry [input stack size=5000]」なるエラーになります

見出し内に `@<code>` や `@<tt>` を使っており、かつハイパーリンクを有効にするとマクロの解決に失敗します。

- [#1432](https://github.com/kmuto/review/issues/1432)

次の内容を sty/review-custom.sty に記述することでエラーを回避できます（Re:VIEW 4.1 で反映予定です）。

```
\g@addto@macro\pdfstringdefPreHook{%
  \def\reviewbreakall#1{#1}}
```

----

## 既存プロジェクトのバージョンアップ追従

既存のプロジェクトを更新するには、Re:VIEW 4.0 をインストール後、プロジェクトフォルダ内で `review-update` コマンドを実行してください。

```
$ review-update
** review-update はプロジェクトを 4.0.0 に更新します **
config.yml: 'review_version' を '4.0' に更新しますか? [y]/n 
プロジェクト/sty/review-base.sty は Re:VIEW バージョンのもの (/var/lib/gems/2.5.0/gems/review-4.0.0/templates/latex/review-jsbook/review-base.sty) で置き換えられます。本当に進めますか? [y]/n 
プロジェクト/sty/review-jsbook.cls は Re:VIEW バージョンのもの (/var/lib/gems/2.5.0/gems/review-4.0.0/templates/latex/review-jsbook/review-jsbook.cls) で置き換えられます。本当に進めますか? [y]/n 
完了しました。
```

　

続いて、リリースノートをベースに、新規に導入した機能や変更点について理由を挙げながら解説します。

## 新機能

### IDGXML ファイルをまとめて生成する、review-idgxmlmaker を導入しました

maker を唯一用意していなかった InDesign 向けの IDGXML 形式ですが、このたびようやく導入しました。

```
review-idgxmlmaker [オプション] 設定yamlファイル
```

オプションは次の2つです。

* `-w 幅`: 版面の幅を mm 単位で指定します。表の幅の設計時に利用されます。
* `-f フィルタファイル`: IDGXML データを加工するフィルタプログラムを指定します。フィルタは標準入力で IDGXML データを受け付け、標準出力に加工結果を戻すように作成しておく必要があります。ファイル名を知りたいときには、環境変数 `REVIEW_FNAME` が渡っているので、それを使うようにしてください。

### review-textmaker は、imgmath パラメータが有効になっている場合に、数式を画像化するようになりました

HTML/EPUB 向けに提供していた TeX 数式の画像ファイル化ですが、textmaker でも利用できるようにしました。数式の画像ファイル化の詳細については、[Re:VIEW フォーマットガイド](https://github.com/kmuto/review/blob/master/doc/format.ja.md#) を参照してください。

Re:VIEW で作るつもりではなくても、数式ファイルをまとめて作りたいという用途に便利です。

### review-init に `-w` オプションを指定することで、Web ブラウザ上で TeX のレイアウトができるウィザードモードを用意しました

今から考えるとウィザードってなんか古い感じもするなという気もしますが、まぁウィンドウモードでもなんとでも考えていただければ。ともかく、LaTeX用の最初の版面設計をWebブラウザ上でできるようにしてみました。プロジェクトを作成するときに `-w` オプションを付けます。

```
review-init -w プロジェクト名
```

これで、デフォルトでは TCP 18000 ポートで Web サーバが起動するので、http://localhost:18000/ に接続することで版面設計ができます。あと、電子版用の config-ebook.yml も作ります。実装をがんばったので、褒め称えてもいいんですよ!!

![ウィザードモード](images/wizard.png)

ポート等を変更したいときには `--port ポート番号` や `--bind バインドアドレス` を指定できます。Docker の場合には docker コマンドに `-p 18000:18000` オプションを指定すれば、ホスト側の 18000 ポートに接続して同様に http://localhost:18000/ で開けるはずです。

現時点のバージョンではこの設定インターフェイスは「新規作成」のみで、「既存のプロジェクトに対する再設定」はできません。将来もっといろいろと Web ブラウザ上で設定ということになると、Node.js 等を利用した大掛かりなものになって、review.gem とは分離した形になるかもしれません。ただ、コメント付きの YAML ファイルの再設定を安全にこなすのは正直良い方法が思い浮かばないです。

### 実験的実装として、複数行から段落を結合する際に、前後の文字の種類に基づいて空白文字の挿入を行う機能を追加しました

もともとの Re:VIEW の仕様として、複数行で段落を表現している場合、テキストや IDGXML 等に変換したときには組版処理向けに「単純に結合」していたのですが、英語の文章だったりするとスペースが消えてしまい、うまくないことになります。

```
this is a
pen.
↓
this is apen.
```

前後を見て日本語なら入れないようにすればいいのでは？ と単純に考えてしまいますが、日本語の文字とはという定義に始まり(たとえば句読点やパンクチュエーションなどの扱い)、そこに Re:VIEW 命令が来た場合にどうするかといったいろいろと頭の痛い問題があります。

Re:VIEW 公式のスタンスとしては、段落内のスペースを確実に表現したいのであれば「1行1段落にする」ことを推奨します。TeX の場合だと問題ないように見えるのですが、これは TeX のエンジンが文字カテゴリを判断して結合時に空白の挿入有無を決めてくれているからです。HTML や IDGXML、テキストなどほかの表現方式では、そういうエンジン側への委託はできません。

今回、実験的に Mozilla Firefox の行結合ロジックを少し改変し (Firefox のやり方だとちょっと空白が余分に入りすぎると思われるため)、実装してみました。この機能を利用するには、Unicode の文字カテゴリ判断をするための unicode-eaw gem をインストールした上で、config.yml に `join_lines_by_lang: true` を追加します。

## 非互換の変更
### 通常の利用では使われることがないので、review-init の実行時に空の layouts フォルダを作成するのをやめました

layouts/layout.html.erb や layouts/layout.tex.erb を置いて枠組みを変えることができるんですが、HTML のほうはあまり変えるようなものでもなく、TeX のほうは Re:VIEW 3 で設定が全部 TeX マクロ化されて枠組みのほうを変える必要はなくなっています。

ということで、普通使わない空フォルダがあっても仕方がないので、今回から review-init ではこのフォルダは作成しません。もちろん必要であれば、任意に layouts フォルダを作ってファイルを置き、枠組みを変えることは引き続き可能です。

### PDFMaker: `@<code>`、`@<tt>`、`@<tti>`、`@<ttb>` で空白文字が消えてしまう問題を修正しました。および利便性のために、文字列が版面からあふれるときに途中で改行するようにもしました

Re:VIEW 3 で LaTeX 変換した際にコード類を `\texttt` のようにベタに書くのではなく `\reviewtt` のように抽象化した名前をいったん経由するようにしたのですが、そうすると空白文字が消されてしまうという罠があるのでした。LaTeX 難しい。

@zr_tex8r さんからマクロの実装例をいただき、`@<code>`、`@<tt>`、`@<tti>`、`@<ttb>` において、空白文字の保持および、版面からあふれそうになったら折り返すようになりました。

### `//texequation`、`//embed`、`//graph` はもともとインライン命令を許容しないので、内容のエスケープもしないようにしました。また、末尾に余計な空行が加わるのも防ぐようにしました

記載のとおりです。非互換変更というよりは、これまでが不具合だったと言えるので、ある意味バグ修正ですね。

### PDFMaker: コラム内での使用を考えて、表の配置のデフォルトを htp (指定位置→ページ上→独立ページの順に試行) から H (絶対に指定位置) にしました (review-style.sty の `\floatplacement{table}` の値)

後方互換性を考えて review-jsbook では表の位置を htp にしていたのですが、コラム等の囲み内で使えないのはやっぱり気付きにくくてよくないので、図と同様に H をデフォルトにしました。

プロジェクトの sty/review-style.sty で定義しているので、昔の状態に戻したければこのファイルを変更してください。

### PDFMaker: コードリスト内では和文欧文間の空きを 1/4 文字ではなく 0 にするようにしました

review-jsbook・review-jlreq において和文・欧文間は 1/4 文字空きが入るのがデフォルト (xkanjiskip 設定) なのですが、コードリスト内だとこの空きが入ると半角スペースのように見えて気になるので、コードリスト内ではこの空きが入らないようにしました。

rsty/review-style.sty の `\reviewlistxkanjiskip` で定義している (`\z@` で 0 にしている) ので、必要であればこの値を変更してください。

### config.yml の目次を制御する toc パラメータの値は、これまで null (false、目次は作らない) でしたが、一般的な利用方法を鑑みて、デフォルトを true (目次を作る) に切り替えました

書籍を作る人は普通目次を入れるでしょうし、EPUB では目次はいらないというのが通説だったのですが、Kindle では物理目次必須ということで、true をデフォルトにするほうが妥当という判断です。

## バグ修正
### review-jlreq がタイプミスのために一部の jlreq.cls バージョンで正しく動作しないのを修正しました

jlreq.cls がまだムービングターゲットで、後方互換性をとるのがなかなか難しいのですが、Debian 10 に入っている jlreq.cls 20190115 バージョンは最低限サポートします。

### re ファイルが改行コード CR で記述されたときに不正な結果になるのを修正しました

CR コードを使っているケースは少なめかもしれませんが、macOS のエディタ保存で生じることがあるようです。Ruby の IO クラスが改行コードまわりをうまくやってくれるので、簡単なパッチで済みました。

### PDFMaker: review-jlreq において `//cmd` のブロックがページをまたいだときに文字色が黒になって見えなくなってしまうのを修正しました

tcolorbox マクロの設定をミスしていました。

### PDFMaker: `@<column>` で「コラム」ラベルが重複して出力されるのを修正しました

なぜこれまで気付かなかったのか不思議ですね……。

### PDFMaker: gentombow.sty と jsbook.cls は review-jsbook の場合のみコピーするようにしました

review-jlreq 向けの改善です。

### PDFMaker: LuaLaTeX で review-jlreq を使ったときに壊れた PDFDocumentInformation ができる問題を修正しました

PDF メタ情報を入れるのに upLaTeX 向けには special マクロを使っていたのですが、LuaLaTeX ではこれがおかしな挙動につながってしまっていました。エラーにはならないし、evince などでもわからないのでしばらく苦戦しました。

結局 LuaLaTeX の場合は hyperref の hypersetup を使って記述することにしましたが、副作用として hyperref はクラスファイルパラメータで media=ebook のときしか読み込まないので、media=print のときだとメタ情報は入らないことになります。

### PDFMaker: review-jlreq で偶数ページに隠しノンブルが入らなかったのを修正しました

隠しノンブルはトンボのバナー機能を流用して入れているのですが、review-jlreq のトンボを司る jlreq-trimmarks.sty の仕様が変わって奇数ページにしか入らなくなってしまったのが原因でした。

いささか泥縄的な対処で回避しています。将来的には [#1397](https://github.com/kmuto/review/issues/1397) で登録しているように jlreqtrimmarkssetup で置き換えるつもりではあります。

## 機能強化
### IDGXML ビルダで `@<em>` および `@<strong>` をサポートしました

ビルダ間の統一が目的です。

### PDFMaker: コードブロックの各行の処理を `code_line`, `code_line_num` のメソッドに切り出しました

リファクタリングの一貫です。これでコードブロック処理がだいぶ読みやすくなり、扱いやすくなりました。

### PDFMaker: デフォルトのコンパイルオプションに `-halt-on-error` を追加しました。TeX のコンパイルエラーが発生したときに即終了することで問題が把握しやすくなります

これまでは TeX コンパイル時にエラーが出てもひとまず最後まで進んでしまっていたため、結局どこでエラーが出たのかを調べるのが大変でした。早期にエラー終了することで、メッセージを見て原因の追跡がこれまでよりも容易になると思います。

### PDFMaker: コラム内に脚注 (`@<fn>`) があるときの挙動がコラムの実装手段によって異なり、番号がずれるなどの問題を起こすことがあるため、脚注の文章 (`//footnote`) はコラムの後に置くことを推奨します。コラム内に脚注文章が存在する場合は警告するようにしました

review-jsbook ではコラムに framed を使っているので顕在化しないのですが、review-jlreq、あるいはサードパーティのスタイルで tcolorbox のような囲みスタイルをコラムに適用している場合にこの問題が発生します。

Re:VIEW のデフォルト挙動では、コラム内かどうかにかかわらず脚注は本文から連続した番号を使いますが、脚注のテキスト部を tcolorbox を使ったコラムブロックの中に入れてしまうと、脚注番号がアルファベットa, b, c…の形になります。脚注番号3がcになる、というくらいであればまだ被害は少ないのですが、脚注番号が27以上になっていると、アルファベットzよりも大きくなるため、カウンタエラーになります。

そこで、コラム内に脚注テキスト部を発見したときに警告を出すようにしました。コラム脚注のテキスト部は、次のようにコラムを閉じた後ろに置くようにしてください。

```
===[column] コラム
文章@<fn>{c1}

//footnote[c1][コラム脚注] ←×

===[/column]

//footnote[c1][コラム脚注] ←○
```

### YAML ファイルのエラーチェックを強化しました

YAMLに何もエントリがないときには捕捉できずにランタイムエラーを起こしてしまっていたのを、捕捉して妥当なエラーメッセージを出すようにしました。

そのほか、イレギュラーパターンへの対処として次のような変更もしています。

* stylesheet パラメータで指定されたCSSファイルが存在しないときにランタイムエラーになっていたのを修正。
* aut パラメータが空の場合に PDFMaker がエラーになるので、デフォルト値 `["anonymous"]` を適用。
* bookname パラメータのデフォルト値 を `book` に。
* texstyle パラメータのデフォルト値を `["reviewmacro"]` に。
* stylesheet パラメータのデフォルト値を `[]` に。

### Logger での表示時に標準の progrname を使うようにしました

ロガーへの出力にこれまでメッセージ出力側でプログラム名を入れていたのを、Logger 自体に任せるようになりました。

### PDFMaker: 電子版の作成時に、表紙のページ番号を偶数とし、名前を「cover」にするようにしました

`media=ebook` で作成する電子版 PDF において、表紙のページ番号の名前が1、また奇数ページなので続く大扉(奇数)の前に白ページが入るというのがこれまでの挙動でした。

少々悩んだのですが、表紙を偶数ページ扱い(0ページ)として大扉との間に白ページが入らないようにし、また名前を「cover」にするように変更しました。

また、この挙動に合わせて `\frontmatter` の前に `\covermatter` というマクロを呼ぶようにしました。

名前は次のマクロで定義しています。

```
\def\@coverpagezero#1{cover}
```

### PDFMaker: `generate_pdf` メソッドのリファクタリングを行いました

このメソッドでは YAML ファイルを引数に取っていたんですが、ロジックを追いかけてみたら依存関係を除去できそうだったのでリファクタリングしてみました。

これで `@config` パラメータ連想配列と `@basedir` だけで `generate_pdf` を呼び出せるようになったので、YAML ファイルなしでも (たとえば JSON のパースなどをして) PDF を作ることができるようになったわけです。Re:VIEW 公式のほうでは特段の必要性もないので変わらず YAML ファイルを使い続けますが、サードパーティの開発としては面白いこともできるのではないかと思います。

### プロジェクトの新規作成時に登録除外ファイル一覧の .gitignore ファイルを置くようにしました

プロジェクトを全部 git add してコミット、というときに一時ファイルが追加されるのを防ぐための抑止ファイル .gitignore を review-init 時にプロジェクトに置くようにしました。

## ドキュメント
### sample-book の README.md を更新しました

サンプルファイルの sample-book, syntax-book はファイルの重複管理を避けるために rake のルールで Re:VIEW 本体から TeX スタイルファイルのコピーをするようにしています。そのため、 review-pdfmaker の直接呼び出しだとルールが実行されず、エラーになってしまいます。

サンプルファイルの実行については `rake pdf` のように rake 経由での呼び出しをするようドキュメントを変更しました。

通常のプロジェクトにおいても、直接 review-pdfmaker 等を実行するより rake を使ったほうが何かと利点があるのでお勧めします。

### review-jsbook の README.md に jsbook.cls のオプションの説明を追加しました

review-jsbook がベースとしている jsbook.cls 自体のオプションおよび review-jsbook の場合のそれらのオプションの有効無効についての説明を加えました。

新規プロジェクトの sty/README.md にコピーされるので、参照してみてください。

## その他

ほとんどは内部実装のリファクタリングです。つまり、普通のユーザーには影響しませんが、review-ext.rb で拡張・挙動変更をしている場合には影響が及んでいる可能性があります。

### メソッド引数のコーディングルールを統一しました

引数があるときは原則としてカッコを付けるようにしました。

### `Catalog#{chaps,parts,predef,postdef,appendix}` は String ではなく Array を返すようにしました

昔の設定ファイルに即したメソッドを、今の設定配列型に合わせたというところです。扱いとして妥当になりました。

### YAML ファイルの読み込みに `safe_load` を使うようにしました

deprecatedなので。

### `table` メソッドをリファクタリングし、ビルダ個々の処理を簡略化しました

表についてはビルダ間で似たようなことをそれぞれで必死に実装しているところがあり、見通しが悪いものになっていました。そこで、表の表現を Builder クラスで次の3つのメソッドに分けました。

* table_begin: 表本体の始まり (LaTeX なら `\begin{reviewtable}`、HTML なら `<table>`)
* table_rows: 表の各行 (中で tr→th/td と呼ぶ)
* table_end: 表本体の終わり  (LaTeX なら `\end{reviewtable}`、HTML なら `</table>`)

これにより、各ビルダは Builder クラスの `table` メソッドの呼び出しをほぼそのまま利用できます。たとえば HTML ビルダの `table` メソッドは以下のようにすっきりしました。

```
    def table(lines, id = nil, caption = nil)
      if id
        puts %Q(<div id="#{normalize_id(id)}" class="table">)
      else
        puts %Q(<div class="table">)
      end
      super(lines, id, caption)
      puts '</div>'
    end
```

### `XXX_header` と `XXX_body` まわりをリファクタリングしました

上記の table もそうですが、これまでブロック命令を展開する XXX, XXX_header, XXX_body のメソッドの実装範囲がビルダごとに微妙に差異があり、共通化を妨げていました。XXX_header にキャプションのほかにブロック全体の囲みを表すものがあったりなかったりといった具合です。

命名に少し悩んだのですがあまり実装をいじらない範囲という方針を立てて、次のように役割分担をすることにしました。

* XXX: ブロック命令自体。キャプション (XXX_header) およびボディ (XXX_body) の呼び出しと、ブロックのキャプションおよびボディを何かで囲むときにはそれを担う。
* XXX_header: キャプションを出力する。
* XXX_body: ボディ部を出力する。

擬似コードで表すと次のような構造になります。

```
def XXX(lines, caption = nil, ...)
  ブロック開始の文字列出力や処理

  XXX_header(caption)
  XXX_body(caption, lines, ...)

  ブロック終了の文字列出力や処理
end

def XXX_header(caption)
  キャプションの出力
end

def XXX_body(caption, lines, ...)
  ボディ部の出力
end
```

### `Builder#highlight?` メソッドを HTMLBuilder 以外でも利用できるようにしました

HTML ビルダのみが持っていたハイライト利用可否の確認メソッドを共通化しました。といっても今のところ HTML ビルダと LaTeX ビルダ以外は false を返すのみですが。

### mkchap* と mkpart* まわりをリファクタリングしました

Chapter や Part のコンストラクタを Book::Base から分けて見通しをよくしました。

### Travis CI で rubygems を更新しないようにしました

テストが変になるようなので。

### Index まわりをリファクタリングしました

`ReVIEW::Book::Index` から Item クラスまわりを分離しました。

### samples フォルダのサンプルドキュメントに review-jlreq のための設定を追加しました

review-jlreq が壊れていないかのテストとして、samples フォルダの2つとも review-jlreq でテストできるようにしました (`REVIEW_TEMPLATE=review-jlreq REVIEW_CONFIG_FILE=config-jlreq.yml rake pdf`)。

### 用語リストは `:` の前にスペースを入れることを強く推奨するようにしました。スペースがない場合、警告されます

`:` を使った用語リスト箇条書きについては、地の文との区別のために行頭スペースを入れることを推奨します。将来的には、行頭にスペース文字なしで `:` が使われているときに警告なしに単に地の文にする可能性があります。
