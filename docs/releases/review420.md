2020/6/29 by @kmuto

# Re:VIEW 4.2 での変更点

Re:VIEW 4.2 において Re:VIEW 4.1 から変更した点について解説します。

----

2020年6月29日に、Re:VIEW 4 系のマイナーバージョンアップである「[Re:VIEW 4.2.0](https://github.com/kmuto/review/releases/tag/v4.2.0)」をリリースしました。

今回のバージョン 4.2 は、発見された不具合の修正と、新機能を数点導入しています。

----

## 既知の問題

現時点では報告はありません。

----

## 既存プロジェクトのバージョンアップ追従

既存のプロジェクトを更新するには、Re:VIEW 4.2 をインストール後、プロジェクトフォルダ内で `review-update` コマンドを実行してください。

```
$ review-update
** review-update はプロジェクトを 4.2.0 に更新します **
プロジェクト/sty/review-base.sty は Re:VIEW バージョンのもの (/var/lib/gems/2.5.0/gems/review-4.2.0/templates/latex/review-jsbook/review-base.sty) で置き換えられます。本当に進めますか? [y]/n 
プロジェクト/sty/review-jsbook.cls は Re:VIEW バージョンのもの (/var/lib/gems/2.5.0/gems/review-4.2.0/templates/latex/review-jsbook/review-jsbook.cls) で置き換えられます。本当に進めますか? [y]/n 
完了しました。
```

　

続いて、リリースノートをベースに、新規に導入した機能や変更点について理由を挙げながら解説します。

## 新機能

### 図・表・リスト・式のキャプションの位置を内容の上側・下側どちらにするかを指定する `caption_position` パラメータを追加しました

これまでキャプション位置は、次のように固定でした。

 * 図（`//image`）: コンテンツの下
 * 表（`//table`）、リスト（`//list`, `//listnum`, `//emlist`, `//emlistnum`, `//source`, `//cmd`, `//box`）、式（`//texequation`）：コンテンツの上

紙面表現においてこれと異なる形にするには review-ext.rb 等を使って書き換える必要がありました。

新たに `caption_position` パラメータを導入し、コンテンツの上・下どちらにキャプションを置くかを指定できるようにしました。

```
caption_position:
  image: bottom
  table: top
  list: top
  equation: top
```

値は `top`（上）または `bottom`（下）のいずれかです。`list` はリスト類すべて、式は `texequation` ではなく `equation` で指定することに注意してください。

なお、デフォルトから変更したときの見た目について、提供する LaTeX スタイルファイルでは関知していません。必要に応じて適宜調整してください。また、LaTeX でハイライトコードを使っている場合、キャプションの位置はマクロ側でしか調整できないことにも注意してください。

## 非互換の変更
### review-vol を再構成しました・review-index を再構成しました

いろいろ挙動が怪しかったこの2つのコマンドを全面的に書き換えました。これまで使っている人は原作者の青木さんと私くらいだったのではないかと思うので、大きく変わっているといってもピンとこないかもしれません。

review-vol は各章ファイルのサイズ（バイト・文字数・行数・想定ページ数）と章見出しを表示するツールですが、以前のバージョンは部ファイルに対応してない、見出しにインライン命令が使えないなど、いろいろと不便なところがありました。これらに対応すべき全体を書き換えています。

これに伴い、以下の変更があります。

- 部を指定したときに部の下にある各章のサイズを結合して表示する機能はなくなりました。
- `-P`, `--directory` オプションによるフォルダ指定はなくなりました。

```
$ review-vol
  1KB    378C    26L   1P  pre01 ......... 前書き
  0KB      0C     0L   0P  部扉見出し ......... 第I部  部扉見出し
  7KB   2929C   128L   7P  ch01 .......... 第1章  章見出し
  1KB    175C     5L   1P  part2 ......... 第II部  部見出し■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□
 14KB   7898C   336L  14P  ch02 .......... 第2章  長い章見出し■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□
  7KB   2584C    77L   7P  ch03 .......... 第3章  コラム
  1KB    197C    21L   1P  appA .......... 付録A  付録の見出し
  1KB    211C     5L   1P  bib ........... 参考文献
=============================
 28KB  14372C   598L  28P
```

review-index は各章の見出し類を目次として表示します。以前のバージョンでは review-vol 同様に文字数や行数などを表示していましたが、目次を知りたいという目的では不要なので、詳細オプション（`-d`）を付けたときのみそれらを出すようにしました。また、インライン命令の処理なども改善しています。特定の章のみを表示したいときには Maker 系と同じく `-y` オプションで指定できるようにしました。ほか、`-l`（見出しの深さ）、`--noindent`（インデントしない）のオプションがあります。

```
$ review-index
前書き
第I部　部扉見出し
第1章　章見出し
  1.1　節見出し
    1.1.1　項見出し……に脚注を入れるとTeXではエラー
      1.1.1.1　段見出し
  1.2　長い節見出し■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□
    1.2.1　長い項見出し■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□
      1.2.1.1　長い段見出し■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□
    1.2.2　採番する項見出し
  1.3　箇条書き
 …

$ review-index -y ch02 （2章だけ表示）
第2章　長い章見出し■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□
  2.1　ブロック命令
    2.1.1　ソースコード
    2.1.2　図
    2.1.3　表
    2.1.4　囲み記事
  2.2　LaTeX式
 …

$ review-index -y ch02 -l 2 （2レベルまでの表示）
第2章　長い章見出し■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□
  2.1　ブロック命令
  2.2　LaTeX式
  2.3　インライン命令

$ review-index -y ch02 -l 2 --noindent （インデントなし）
第2章　長い章見出し■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□
2.1　ブロック命令
2.2　LaTeX式
2.3　インライン命令

$ review-index -y ch02 -l 2 -d （詳細情報）
=============================
  5361C   163L    10P  ch02
-----------------------------
    52C     1L   0.0P  第2章　長い章見出し■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□■□
  2995C   114L   6.1P    2.1　ブロック命令
   509C    14L   0.8P    2.2　LaTeX式
  1805C    34L   2.5P    2.3　インライン命令
```

review-vol と review-index で文字数などに違いがあるのは、review-vol はファイルの Re:VIEW 命令をほとんど解析・変換せずに算出しているのに対し、review-index はテキストビルダ（PLAINTEXTBuilder）を経由して実際に近い文字数で算出していることが理由です。つまり、review-index のほうがより正確な値を得られますが、ファイル内に構文エラーがあると、そこで算出処理が終了してしまいます。

review-vol で（たとえ中身が少々壊れていても）おおまかに章間のバランスを見極め、review-index で目次構成レベルで詳細に確認する、という使い方をお勧めします。

## バグ修正
### 重複する `@non_parsed_commands` 宣言を削除しました

compiler.rb ファイル内の `initalize` と `do_compile` メソッドの両方で `@non_parsed_commands` を重複定義していました。結局のところどちらで定義するのも挙動的によろしくないことがわかり、メソッド `non_escaped_commands` を用意してその返却値を使うようにしました。

review-ext.rb で挙動を変えていたときには注意してください。

### WebMaker、TextMaker で数式画像が作成されない問題を修正しました

これは Re:VIEW 4.2 開発中に仕込んでしまったバグの修正ですね。4.1→4.2リリース版という更新プロセスならそもそも問題ないはずです。

## 機能強化

### imgmath での数式画像の作成処理を最適化し、高速化しました

100個程度の数式の入った書籍ではこれまで顕在化していなかったのですが、500 以上になると妙に時間がかかるな…と思っていたら、数式を全部リストアップしたところまではよかったのですが、重複を削除せずに愚直に1つずつ画像を作っては上書きしていました（特に pdfcrop で切り出すところが遅い）。

重複を取り除いてから画像を作成するようにして高速化しました。

なお、この開発で上記の「WebMaker、TextMaker で数式画像が作成されない問題を修正しました」の原因になったバグを仕込んでしまっていました…。

### デフォルト以外の固有の YAML 設定を PDFMaker に引き渡したいときのために、`layouts/config-local.tex.erb` ファイルが存在すればそれを評価・読み込みするようにしました

Re:VIEW 3 以降、YAML 設定値は [config.erb](https://github.com/kmuto/review/blob/master/templates/latex/config.erb) 経由で引き渡し、この config.erb で宣言した TeX マクロの値を、クラスファイルやスタイルファイルで参照する、という仕組みになっています。

ただ、ここで引き渡せる YAML 設定値は config.erb で定義しているもののみであり、それ以上のものについてはフックスクリプトでなんとかするか、layouts フォルダに [layout.tex.erb](https://github.com/kmuto/review/blob/master/templates/latex/layout.tex.erb) を置いてこれを書き換えるという方法をとるしかありませんでした。いずれもやや大袈裟です。

Re:VIEW 4.2 でも仕組みは変わりませんが、layouts フォルダに `config-local.tex.erb` というファイルを置いたら、それを `config.erb` の後に評価・読み込みするようにしました。

YAML ファイルが以下だとして

```
…
mycustom:
  mystring: HELLO_#1
  mybool: true
```

`layouts/config-local.tex.erb` はたとえば次のようになります。

```
\def\mystring{<%= escape(@config['mycustom']['mystring']) %>}
<%- if @config['mycustom']['mybool'] -%>
\def\mybool{true}
<%- end -%>
```

これは最終的に次のように展開されます。

```
 …
\makeatother
%% BEGIN: config-local.tex.erb
\def\mystring{HELLO\textunderscore{}\#1}
\def\mybool{true}
%% END: config-local.tex.erb

\usepackage{reviewmacro}
 …
```

こうして定義されたマクロをスタイルファイルなどで参照します。

なお、YAML 設定の引き渡しは、文字列のエスケープ、シリアライズの手段、エラーの対処など考えるべきことが多数あります。既存の config.erb やスタイルファイルなどがどのようになっているか、参考にしてください。

## その他

### GitHub Actions を eregon/use-ruby-action から ruby/setup-ruby に切り替えました

自動ビルドの GitHub Actions で使っていたアクションが不安定だったため、別のアクションに切り替えました。

### テストの際、samples フォルダ内にあるビルド成果物を無視するようにしました

samples の sample-book や syntax-book にビルド中間ファイルが残っていると、これらを使うテストに失敗していました。テストでは一時フォルダにサンプル一式をコピーしてビルドする、という仕組みにしていたのですが、中間ファイルまでコピーして失敗していたというオチです。コピー対象から中間ファイルを除外することで対処しています。

## 終わりに

今回の Re:VIEW 4.2 では review-vol/review-index の再構成以外に大きな修正というほどのものはありませんでしたが、次のバージョンでは、文法にも関わるやや大きめの変更を計画しています（そのため、おそらく次バージョンは 5.0 となりそうです）。お楽しみに。
