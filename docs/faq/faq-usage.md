# FAQ - Re:VIEW の使い方について

FAQ（よくある質問と回答）のこのセクションは、Re:VIEW の使用方法のポインタや、使う上での注意点などをまとめています。

----

## Re:VIEW を動かすにはどのような環境が必要ですか？

Ruby インタプリタ 2.4 以上がインストールされた OS 環境であれば、基本的に動作します。TeX を使った PDF 生成を行う場合は、別途日本語 TeX 環境のセットアップが必要です。

推奨環境は Linux（特に Debian GNU/Linux 安定版 または Ubuntu 安定版）、および macOS です。

Windows でも、ネイティブ環境でのセットアップ、WSL（Windows Subsystem for Linux）でのセットアップの報告があります。

- 現時点では、Ruby 2.4〜3.0のテストのみをしています。もし2.1〜2.3で奇妙な挙動を示すときにはご報告ください。(ただし、やむを得ず古いバージョンには非対応になる可能性はあります)
- 2022年6月のリリースにおいて Ruby 2.7 未満のサポートを停止する予定です。

## Re:VIEW はどうやってインストールしたらよいですか？

Ruby をセットアップ済みであれば、ターミナル（またはコマンドプロンプト）から以下のコマンドでインストールできます。

```
gem install review
```

プレビュー版をインストールするには以下のようにします。

```
gem install review --pre
```

OS の所定の手続きに従って、gem の bin フォルダにパスを通してください。

Gemfile を使っている場合は、以下の行を Gemfile に追加して `bundle` コマンドを実行します。

```
gem 'review'
```

## Ruby はどうやってインストールしたらよいですか？

手順は OS によって異なります。

Debian GNU/Linux、Ubuntu の場合は以下のようにしてインストールできます。

```
apt-get install ruby
```

TeX 環境など完全な環境構築としては、以下のようにするのもよいでしょう。

```
apt-get install --no-install-recommends texlive-lang-japanese texlive-fonts-recommended texlive-latex-extra texlive-generic-extra lmodern fonts-lmodern tex-gyre fonts-texgyre texlive-pictures ghostscript gsfonts zip ruby-zip ruby-nokogiri mecab ruby-mecab mecab-ipadic-utf8 poppler-data cm-super graphviz gnuplot python-blockdiag python-aafigure
```

<!-- ★TODO:macOS、Windows。TeXと合わせて独立ページにしたほうがいい？ -->

## TeX 環境の構築はどうしたらよいですか？

- [FAQ - Re:VIEW の使い方について（TeX PDF）/TeX 環境の構築はどうしたらよいですか？](faq-tex.html)
- [Re:VIEW 向け日本語 TeX Live 環境のセットアップ（Linux、macOS、Windows）](../latex/install-tl.html)

## Docker のイメージはありますか？

以下でセットアップできます。

```
docker pull vvakame/review
```

利用方法などは以下を参照してください。

- [https://github.com/vvakame/docker-review](https://github.com/vvakame/docker-review)

## docker pull で mac M1 (arm64) 用のイメージがありません

2022年1月時点で動作可能な Docker イメージ設定は用意しているのですが、Docker Hub に置く前提としての CI ビルドがうまく動いていません。

[vvakame/docker-review](https://github.com/vvakame/docker-review) 直下にある Dockerfile をダウンロードし、`docker build` コマンドで手元でビルドすれば動作する環境を構築できます。

CI をうまく動作させる方法がわかりましたら下記 PR にご提案お願いします。

- [vvakame/review PR#70](https://github.com/vvakame/docker-review/pull/70)

## 基礎的なガイダンスを記した公式のドキュメントはありますか？

- [Re:VIEW Quick Start Guide](https://github.com/kmuto/review/blob/master/doc/quickstart.ja.md#)
- [Re:VIEW Format Guide](https://github.com/kmuto/review/blob/master/doc/format.ja.md#)
- [その他のドキュメント](https://github.com/kmuto/review/tree/master/doc)

## Re:VIEW の入門書はありませんか？

- [技術書をかこう! 〜はじめてのRe:VIEW〜 改訂版](https://techbooster.booth.pm/items/586727)（PDF・印刷書籍）

## バグを見つけました。どうしたらよいですか？

GitHub の issue ページ
[https://github.com/kmuto/review/issues](https://github.com/kmuto/review/issues)
までお寄せください（日本語または英語）。

## 使い方の質問はどこに投稿するとよいですか？

GitHub の Discussions ページ [https://github.com/kmuto/review/discussions](https://github.com/kmuto/review/discussions) があります。

Twitter で [@kmuto](https://twitter.com/kmuto) に適切な表現でメンションいただければ、可能な範囲でお答えもできます。

## プロジェクト（作業フォルダ）を作るにはどうしたらよいですか？

`review-init` コマンドを使います。

```
review-init プロジェクト名
```

Re:VIEW 4 以降では、review-init の実行時に TeX のレイアウトを Web ブラウザ上で設定する機能が備わっています。`-w` オプション付きで作成します。

```
review-init -w プロジェクト名
```

すると、デフォルトではポート 18000 を使った小さな Web サーバが起動します。Web ブラウザで http://localhost:18000 につなげてみると、紙面のレイアウトを GUI のように操作できる画面になります。

プロジェクト作成のデフォルトでは doc サブフォルダが作成され、Re:VIEW のドキュメントがコピーされますが、不要なときには `--without-doc` オプションを付けます。

```
review-init --without-doc プロジェクト名
```

Re:VIEW 4.1 以降では、config.yml のコメントを除去する `--without-config-comment` オプションがあります。

```
review-init --without-config-comment プロジェクト名
```

Re:VIEW 3 以降では、任意の Web サーバーからプロジェクトに適用する各種ファイルをダウンロードすることもできます。Web サーバー側では、zip 形式で初期プロジェクトのうち上書きあるいは新規作成したいフォルダおよびファイルをまとめておきます（アーカイブURLにはローカルファイルを指定することもできます）。

```
review-init -p アーカイブURL プロジェクト名
```

## プロジェクトにどのようにコンテンツを置いたらよいですか？

`review-init` コマンド実行後、プロジェクトには次のようなフォルダおよびファイルが置かれます。

- プロジェクト名と同名の「.re」拡張子付きファイル：空の初期ファイル。ここに内容を入れていく（catalog.yml を変更すれば、このファイルでなくてもよい）
- config.yml：書名など各種メタ情報の設定ファイル
- catalog.yml：目次構成ファイル。re ファイルを列挙して順序を決定する
- doc：ドキュメント
- Rakefile：`rake` コマンド用のルールファイル
- libs：Rakefile ルールの実体など
- images：画像を置くフォルダ
- layouts：LaTeX や HTML のテンプレートレイアウト（Re:VIEW 4 以降では作成されない。必要なときには手動で作成）
- style.css：EPUB/HTML のスタイルシート
- sty：LaTeX のスタイルファイル

基本的なコンテンツの置き方は次のようになります。

- 章ごとの re ファイルはプロジェクトフォルダ直下に置く（Re:VIEW 3 からは contentdir でも指定可）
- 画像は images フォルダに置く。章あるいはビルダによってサブフォルダを作成することも可
- CSS ファイルはプロジェクトフォルダ直下に置く

- [Re:VIEWクイックスタートガイド](https://github.com/kmuto/review/blob/master/doc/quickstart.ja.md#)
- [プロジェクト直下がたくさんの re ファイルだらけでごちゃごちゃしてしまいました。サブフォルダにまとめて置くことはできますか？](#d127d7603580e36bf6a20ee2b0f3a264)

## Re:VIEW がバージョンアップしたときに設定を追従するにはどうしたらよいですか？

Re:VIEW 3 から `review-update` というコマンドが導入されました。このコマンドをプロジェクトフォルダ内で実行すると、config.yml や sty フォルダなどを最新バージョンに適したものに更新できます。

## re ファイルを書くのに専用のエディタは必要ですか？

re ファイルは命令を含めてすべてテキストで表現されるので、UTF-8 文字エンコーディングをサポートし、プレインテキスト形式での読み込み・書き出しが可能なテキストエディタであれば OS・ソフトウェアを問わず何でも利用できます。

ただ、Re:VIEW 固有の命令を記入したり色分け表示したりといった支援モードが提供されているエディタを使ったほうが、執筆および編集には便利でしょう。

## re ファイルでの執筆・編集を支援するエディタにはどのようなものがありますか？

- Emacs：[review-el](https://github.com/kmuto/review-el)
- 秀丸：[review-hidemaru](https://github.com/kmuto/review-hidemaru)
- CotEditor：[Re:VIEW Color macro for CotEditor](https://github.com/kmuto/review-coteditor)
- mi：[miエディタ用のReVIEWモード作ってみた](http://seuzo.net/entry/2012/02/21/222036)
- Atom：[Re:VIEW support for Atom](https://atom.io/packages/language-review)
- Visual Studio Code：[vscode-language-review](https://github.com/atsushieno/vscode-language-review/blob/master/README.md#)、[VSCode: yet another Re:VIEW languages extension](https://github.com/erukiti/ya-language-review)
- Vim：[syntax and helpers for ReVIEW text format](https://github.com/moro/vim-review)、[Vim syntax for Re:VIEW](https://github.com/tokorom/vim-review)

## Visual Studio Code を使ったところ、^H などのおかしな文字が入り、PDF の生成に失敗します!

Re:VIEW 側の問題ではないのですが、Visual Studio Code（VS Code）でバックスペースの文字が入ってしまうことがあるようです。設定と拡張機能によって対処する手段が示されています。

- [VS Code の日本語入力で制御文字が紛れ込む問題](https://astropengu.in/blog/2/)

## 図版はどこに置くのですか？ また、どのような形式に対応していますか？

図版の画像ファイルは、images フォルダに配置します。さらにサブフォルダで分けることもできます。このときの探索順序は次のようになっています。

```
1. images/<builder>/<chapid>/<id>.<ext>
2. images/<builder>/<chapid>-<id>.<ext>
3. images/<builder>/<id>.<ext>
4. images/<chapid>/<id>.<ext>
5. images/<chapid>-<id>.<ext>
6. images/<id>.<ext>
```

どの画像形式に対応するかは、使用するビルダに依存します。

- HTMLBuilder (EPUBMaker、WEBMaker)、MARKDOWNBuilder: .png、.jpg、.jpeg、.gif、.svg
- LATEXBuilder (PDFMaker): .ai、.eps、.pdf、.tif、.tiff、.png、.bmp、.jpg、.jpeg、.gif
- それ以外のビルダ: .ai、.psd、.eps、.pdf、.tif、.tiff、.png、.bmp、.jpg、.jpeg、.gif、.svg

Re:VIEW 3 以降では、大文字の混ざった拡張子にも対応します。Re:VIEW 2 では「PNG」など大文字のファイル拡張子の場合はヒットしないので注意してください。

- [Re:VIEW フォーマットガイド](https://github.com/kmuto/review/blob/master/doc/format.ja.md#) の「図」

## config.yml ファイルはどのような役目を持っていますか？

config.yml は、コンテンツの内容を除く、ほとんどの設定および Re:VIEW の制御を司るメタ情報ファイルです。

このプロジェクトが準拠するRe:VIEW バージョン、書名、著者名、刊行日付、見出しへの採番レベル、目次や奥付の有無、デバッグ状態遷移の有無、カバー画像、スタイルシート、LaTeX の使用スタイルなど、多くの設定があります。詳細については、展開された config.yml ファイルのコメントの説明を参照してください。代表的な設定のみを抽出した、config.yml.sample-simple もあります。

- [config.yml.sample](https://github.com/kmuto/review/blob/master/doc/config.yml.sample)
- [config.yml.sample-simple](https://github.com/kmuto/review/blob/master/doc/config.yml.sample-simple)

## catalog.yml ファイルはどのような役目を持っていますか？

## PDF（review-pdfmaker）と EPUB（review-epubmaker）、あるいは印刷版 PDF と 電子版 PDF のように出力方法によって若干異なる設定にしたいと思います。重複する内容の yml ファイルを作らずに済みませんか？

`inherit` を使うと、ベースの yml ファイルを読み込みつつ、設定の追加や変更ができます。

たとえば config.yml で次のようにしていたとします。

```yaml
 …
date: 2018-7-21
 …
```

ここから電子 PDF 版用だけ別の日付にしたいとして、config-epdf.yml などの適当なファイル名で、`inherit` を使って config.yml を取り込み、設定値を上書きします。

```yaml
inherit: ["config.yml"]
date: 2018-9-27
```

この config-epdf.yml を使うには、`review-pdfmaker config-epdf.yml` のように指定して実行するか、`REVIEW_CONFIG_FILE` 環境変数に `config-epdf.yml` を設定した上で `rake` コマンドを実行します。

```
REVIEW_CONFIG_FILE=config-epdf.yml rake pdf
```

ある設定を消したいときには、値として `null` を指定します。

## 「図」「リスト」などの一部の固定文字列は locale.yml ファイルで変えられるようですが、どのように書いたらよいですか？

日本語用にはまず `locale: ja` という行を入れた後、Re:VIEW の `lib/erview/i18n.yml` の定義を元に置き換えるものを定義します。たとえば図は `image`、リストは `list` が文字列定義名です。

```
locale: ja
image: 図
list: リスト
```

- [Re:VIEW フォーマットガイド](https://github.com/kmuto/review/blob/master/doc/format.ja.md#) の「国際化（i18n）」
- [i18n.yml](https://github.com/kmuto/review/blob/master/lib/review/i18n.yml)

## EPUB に変換するにはどうしたらよいですか？

以下のようにして変換します。

```
rake epub
REIVIEW_CONFIG_FILE=config-epub.yml rake epub （config-ebpub.ymlから作成したいとき）
```

以下でも可能です（`rake epub` は中でこのコマンドを実行しています）。

```
review-epubmaker config.yml
```

## LaTeX を使った PDF に変換するにはどうしたらよいですか？

以下のようにして変換します。

```
rake pdf
REIVIEW_CONFIG_FILE=config-ebook.yml rake pdf （config-ebook.ymlから作成したいとき）
```

以下でも可能です（`rake pdf` は中でこのコマンドを実行しています）。

```
review-pdfmaker config.yml
```

## Web ページに変換するにはどうしたらよいですか？

以下のようにして変換します。

```
rake web
```

以下でも可能です（`rake web` は中でこのコマンドを実行しています）。

```
review-webmaker config.yml
```

## プレインテキストに変換するにはどうしたらよいですか？

以下のようにして変換します。

```
rake text
```

以下でも可能です（`rake text` は中でこのコマンドを実行しています）。

```
review-textmaker config.yml
```

校正ツールにかけるなどの理由で一切装飾のないプレインテキストが必要なときには、以下のようにします。

```
rake plaintext
```

または

```
review-textmaker -n config.yml
```

## Re:VIEW の命令や記法に馴染めそうもありません。Markdown で記述できませんか？

[md2review](https://github.com/takahashim/md2review)があります。gem としても配布されているので、以下のようにインストールできます。

```
gem install md2review
```

変換は以下のようにします。

```
md2review mdファイル > reファイル
```

命令体系が異なるため、変換結果の re ファイルの手直しは必要です。

ほかの方法として、[pandoc2review](https://github.com/kmuto/pandoc2review) があります。汎用ドキュメント変換ソフトウェアである pandoc を利用し、Markdown を含め docx などの多様なドキュメント形式から re ファイルに変換できます。

```
pandoc2review mdファイル > reファイル
```

pandoc2review のサンプルには、Re:VIEW 環境と統合することで、Markdown ファイルを原稿データとしたまま Re:VIEW 原稿と混在して利用する例も収録されています。

## Markdown に変換することはできますか？

Markdown については実験的な対応をしたビルダを収録しています。rake ルールや1コマンドで全部を変換するような仕組みはないのですが、以下のようにして変換できます。

```
review-compile --target=markdown reファイル > mdファイル
```

## `@<code>` などの頻出するインライン命令だけ Markdown 的に記述することはできませんか？

Re:VIEW では、インラインの命令は一貫した `@<命令>{〜}`とし、見出しや箇条書き以外の例外はこれ以上増やさないことに決めています。インライン命令の入力の煩雑さについては、エディタ支援環境に頼ったほうがよいでしょう。

それでも Markdown 的なリテラル文字でのインライン記法を使いたいときには、Compiler#text の挙動を置き換えることで一応実現できます。

以下の review-ext.rb をプロジェクトフォルダに設置すると、テキスト内のバッククォートで囲まれた範囲を `@<code>` 命令に内部で置換します。

```
module ReVIEW
  module CompilerOverride
    def text(str)
      super(str.gsub(/\`(.+?)\`/, '@<code>$\1$'))
    end
  end

  class Compiler
    prepend CompilerOverride
  end
end
```

これは推奨するものではなく、あくまでも実装事例です。利用および改良にあたってのヒントを提示しておきます。

- `{}` ではなく `$$` で囲んでいるのは、`{}` の文字をリテラルに使う可能性を考えたためです。リテラルな `$` を含んでしまう場合は、a. `||` にする、b. そう使いたいものだけ `@<code>` を普通に使う、c. 内容を読んで `{}` か `$$` か `||` かのどれを使うかまじめに判断するよう実装する のいずれかの対策が必要です。
- バッククォートのエスケープは考慮していません。まじめに実装するか、途中で改行して開始終了の対応関係が存在しないように見せるかといった対策になります。
- より Markdown っぽく複数の置換をしたくなるかもしれませんが、素朴に置換を追加すると、置換済みのものにさらに別の置換を重ねてしまうことになります。まじめに実装するには、済んだものはいったん退避しておくなどの複雑な処理が必要です。

## pandoc で Re:VIEW の書式はサポートされますか？

現時点では実装の報告はありません。[pandoc2review](https://github.com/kmuto/pandoc2review) で「ほかの形式のドキュメントから Re:VIEW に変換」はできます。

## Sphinx で Re:VIEW の書式はサポートされますか？

- [Sphinx ReVIEW builder](https://github.com/shirou/sphinxcontrib-reviewbuilder)

## LaTeX を使いたくないのですが、ほかの PDF 作成方法はありませんか？

たとえば InDesign を使う方法と、CSS 組版を使う方法があります。

- InDesign：IDGXML 形式に変換し、レイアウトデザイン向けに調整した上で、Adobe InDesign で半自動 DTP を行う。
- CSS組版：EPUB に変換し、EPUB をそのまま PDF 変換する（[VersaType Converter](https://trim-marks.com/ja/)、[EPUB to PDF変換ツール](https://www.antenna.co.jp/epub/epubtopdf.html) など）か、EPUB の HTML を結合し（Re:VIEW 3 から review-epub2html というコマンドを用意しています）、Web ブラウザ上で整形したものを PDF として保存する（[Vivliostyle.js](https://vivliostyle.org/) など）。後者については @at_grandpa 氏による、ひとそろいセットの [Re:VIEW+CSS組版 執筆環境構築](https://github.com/at-grandpa/review-and-css-typesetting) が公開されています。

これらのいずれも困難であったり、あるいは手作業工程の DTP オペレータに引き渡すということであれば、Re:VIEW 原稿をプレインテキストに変換（`rake text`）して手作業でページを制作していくほうが妥当かもしれません。

## 表のセル区切りは、なぜ空白文字ではなく「タブ1つ」なのですか？

コード断片など、セル内で空白を文字として扱いたい場合があるからです。

Re:VIEW 4.1 以降では、`table_row_separator` パラメータの値で区切り文字を変更できます。

- tabs (1文字以上のタブ文字区切り。デフォルト)
- singletab (1文字のタブ文字区切り)
- spaces (1文字以上のスペースまたはタブ文字の区切り)
- verticalbar ("0個以上の空白 | 0個以上の空白"の区切り)

Re:VIEW 4.0 以前では、`lib/review/builder.rb` の次のメソッドで実装しているので、`review-ext.rb` などを使ってビルダの挙動を上書き（たとえば `/\s{2,}/` など）すれば、空白文字による区切りも可能です。

```
    def table(lines, id = nil, caption = nil)
        …
        rows.push(line.strip.split(/\t+/).map { |s| s.sub(/\A\./, '') })
```

<!-- ## 表のセルを連結するにはどうしたらよいですか？ -->

## 別フォルダにあるソースコードファイルの一部を原稿内に取り込みたいと思います。動的に取り込む方法はありますか？

- [コードリストブロック内でファイルの取り込みやコマンド実行を動的に行う](../reviewext/list-exec.html)

## catalog.yml での最小単位は章単位ですが、節や項に分けることはできませんか？

現時点の Re:VIEW の実装では、章よりも小さく分割した単位でファイルを扱うことはできません。

ただし、`#@mapfile(ファイル名)` 命令と `review-preproc` コマンドを使って、分割ファイルを結合することはできます。

たとえば章ファイルでは次のようにしておき、

```
= 章見出し
#@mapfile(section1.re)
#@end

#@mapfile(section2.re)
#@end
```

節の内容となる section1.re と section2.re ファイルを別に用意します。

section1.re の内容
```
== 節1
ABC
```

section2.re の内容
```
== 節2
DEF
```

この状態で `rake preproc` あるいは `review-preproc --replace 章ファイル` を実行すると、章ファイルが次のように更新されます。

```
= 章見出し
#@mapfile(section1.re)
== 節1
ABC
#@end

#@mapfile(section2.re)
== 節2
DEF
#@end
```

実行するたびに `#@mapfile` 〜 `#@end` の中身が書き換えられます。

- [review-preproc ユーザガイド](https://github.com/kmuto/review/blob/master/doc/preproc.ja.md#)

## 見出しの一覧を出力することはできますか？

`review-index` コマンドで表示できます。

## Re:VIEW に対応した日本語校正ツールはありますか？

- [RedPen](http://redpen.cc/)
- [textlint](https://textlint.github.io/) および [textlint-plugin-review](https://www.npmjs.com/package/textlint-plugin-review)
- [テキスト校正くん](https://marketplace.visualstudio.com/items?itemName=ICS.japanese-proofreading)

## 変換途中で独自の処理を挟むことはできますか？

- [フックで LaTeX 処理に割り込む](../latex/tex-hook.html)

## Re:VIEW の標準の命令処理を変えたり、新たな命令を追加したりすることはできますか？

`review-ext.rb` というファイルを使い、Re:VIEW のロジックを上書きできます。

- [Re:VIEW のモンキーパッチによる拡張の基本](../reviewext/review-ext-basic.html)

## 索引を入れるにはどうしたらよいですか？

`@<idx>` や `@<hidx>` インライン命令を使って索引を埋め込むことができます。ただし、埋め込んだ索引の抽出・整列・表示は、現時点では、LaTeX のみでの対応です。EPUB/Web ではやや無理矢理ですが対処方法を示しています（以下のリンクを参照）。

- [索引の使い方](https://github.com/kmuto/review/blob/master/doc/makeindex.ja.md#)
- [EPUB/Web で索引を使うにはどうしたらよいですか](faq-epub.html#caf3377e1c0f31b997f123c21fce7635)

## プロジェクト直下がたくさんの re ファイルだらけでごちゃごちゃしてしまいました。サブフォルダにまとめて置くことはできますか？

Re:VIEW 3.0 から、config.yml の `contentdir` パラメータを使って re ファイルを保持するサブフォルダを指定することができます。指定のサブフォルダに格納できるのは re ファイルのみで、画像はプロジェクトフォルダ直下にある images フォルダに入れることに変わりはありません。

## UML やグラフの生成ツールから動的に生成して配置することはできますか？

`//graph` ブロック命令を使い、Graphviz、Gnuplot、Blockdiag、aafigure、PlantUML のソースを記述して画像を生成できます。

- [Re:VIEW フォーマットガイド](https://github.com/kmuto/review/blob/master/doc/format.ja.md#) の「グラフ表現ツールを使った図」

## インライン命令内で入れ子ができません！

Re:VIEW の言語解析ロジック上、および記法の複雑化を避けるため、インライン命令は入れ子にすることはできません。

複合した結果になる新たな命令を `review-ext.rb` で定義する必要があるかもしれません。

## インライン命令内で「}」を文字として表現したいときにはどうしたらよいですか？

`\}` と記述します。なお、`{` のほうはインライン命令内でそのまま利用できます。

よって、たとえば `{}` という内容を入れたいときには、`@<tt>{{\}}` のようになります。

## インライン命令内の最後で「\」を文字として表現したいときにはどうしたらよいですか？
インライン命令内の `\` は通常そのまま文字として扱われますが、唯一、命令の末尾に入るときだけ `\}` という表現と区別が付けられなくなります。

- インライン命令内の文字列が単一の `\` だけであれば、`\\` と表現し、`@<tt>{\\}` と記述できます。
- 複数の文字からなる文字列（たとえば `C:\Users\`）の場合は `\\` ではうまくいきません。フェンス記法を使い、`@<tt>|C:\Users\|` または `@<tt>$C:\Users\$` とします。

## @\<m\>命令を使って TeX 式を記述したところ、「}」がたくさん登場して都度「\}」とするのが大変です。何か対策はありますか？

`||` または `$$` で囲む、フェンス記法があります。フェンス記法内では `\` や `}` のエスケープは不要です（逆に、`||` の場合は `|`、`$$` の場合は `$` の文字は文字列内で使用できなくなります）。

`@<m>|\frac{1}{2}|` または `@<m>$\frac{1}{2}$` のようになります。

## ブロック命令内で「//}」を文字として表現したいときにはどうしたらよいですか？

いくぶん不格好ですが、`@<embed>` 命令を使って「/」を囲み、ブロックの閉じ側と判定されるのを避けるように記述するとよいでしょう。

```
//emlist{
この行から//emlist内の内容です
//emlist{
リスト。次の行はブロック閉じと見なされない
@<embed>{/}/}
この行まで//emlist内の内容です
//}
```

## 箇条書きを入れ子にするにはどうしたらよいですか？

ビュレット箇条書き `*` は、`**` のように深さに応じて数を増やすことで入れ子ができます。

```
 * 第1の項目
 ** 第1の項目のネスト
 * 第2の項目
 ** 第2の項目のネスト
 * 第3の項目
```

Re:VIEW 5.0 では、その他の箇条書きの入れ子や、ビュレット箇条書きの下に番号箇条書きを入れる、箇条書きの中に図表や段落を含める、といったことが `//beginchild` 〜 `//endchild` を使って表現可能です。あまり re ファイルの見た目はよくありませんが…。

```
 * UL1

//beginchild
#@# ここからUL1の子

UL1の続きの段落

 1. UL1-OL1

//beginchild
#@# ここからUL1-OL1の子

UL1-OL1-PARAGRAPH

 * UL1-OL1-UL1
 * UL1-OL1-UL2

//endchild
#@# ここまでUL1-OL1の子

 2. UL1-OL2

 : UL1-DL1
        UL1-DD1
 : UL1-DL2
        UL1-DD2

//endchild
#@# ここまでUL1の子

 * UL2
```

Re:VIEW 4 以下では、review-ext.rb での書き換えによる対策として、[複雑な箇条書きの入れ子に対応する](../reviewext/nest.html) を参照してください。

## Re:VIEW は夏時間に対応していますか？

Ruby ライブラリおよび OS の対応範囲での対応となります。実際のところ、Re:VIEW の実装で「現在時刻」に基づく処理が発生するのは、以下の2箇所のみです。

- review-init 実行時に config.yml ファイルに書き出す、date: および history: のパラメータの日付の生成
- review-epubmaker 実行時に OPF メタファイルに書き出される modified タイムスタンプの生成（バージョン 2.5 まではローカルタイム（ただし不適切な時差表記）、バージョン 3 以降は UTC）

前者は日付だけなので、OS の時刻が正しく設定されていれば夏時間は影響しません。後者は「Re:VIEW バージョン 2.5 までを使用し」「夏時間からの時刻の巻き戻しの前後で2回の EPUB ビルドをして」「その2つの EPUB をリーダー上で更新する」ときに「リーダーが modified タイムスタンプを見て更新の有無を判断する」場合に、更新がうまくいかないかもしれません。要するに、まず発生することはない、ということです。

## 段落を空行区切りではなく、改行をもって区切りにすることはできませんか？

Re:VIEW は空行を何らかの意味区切りとするという暗黙の想定をしており、この挙動を変更することは推奨しません。ただ、段落を判定しているのは各ビルダの `paragraph` メソッドなので、これを書き換えれば改行で区切りとすることは可能です。以下に LATEXBuilder の場合の挙動変更例を提示します。

```
module ReVIEW
  module LATEXBuilderOverride
    def paragraph(lines)
      # blank→結合→blankではなく、行ごとに前後blankを入れて段落化する
      lines.each {|line| blank; puts line; blank}
    end
  end
  class LATEXBuilder
    prepend LATEXBuilderOverride
  end
end
```

## 英語の段落を記述したところ、改行のところで単語間がつながってしまいます

たとえば次のような段落を記述すると、

```
Hello, I
write an
article.
```

TeX 以外の変換出力では「Hello, Iwrite anarticle.」とつながってしまいます（TeX でできているように見えても、それは Re:VIEW ではなく TeX 側に段落判定を委ねているからに過ぎません）。

基本的に、英語段落を入れたいときには、スペースのところで改行せず、1行にまとめるようにしてください。

```
Hello, I write an article.
```

実験的な言語判定実装として、Re:VIEW 4.0 では unicode-eaw ライブラリを使った行結合を用意しました。`gem install unicode-eaw` で gem をインストールした上で、config.yml に `join_lines_by_lang: true` のパラメータを追加してみてください。

## ファイル名やラベルに避けたほうがよい文字はありますか？

Re:VIEW のシステム自体は OS が許容する範囲での文字をおおむね利用できますが、特に TeX に変換した場合には空白文字や一部の記号文字の利用で奇妙な症状あるいはエラーになることがあります。

トラブルを避けるため、ファイル名やラベル名は半角英字アルファベット（a〜z、A〜Z）、数字（0〜9）、あとは`_`、`.`、`-`、`+`という程度に留めておくことを推奨します。

Re:VIEW 5.0 以降では、TeX または EPUB で問題になる可能性がある ID 文字列に警告が表示されます。

## 後注を作ることはできますか

Re:VIEW 5.3 以降では、通常の脚注のほかに章の末尾に注釈を配置する後注の機能が追加されています。

`//endnote` 命令で後注内容を記述し、`@<endnote>` 命令で後注を参照します。実際に後注一覧を配置する箇所には、`//printendnotes` 命令を使います。

```
 …
ビルダはRe:VIEW形式の原稿ファイルを「HTML」や「LaTeX」などに変換する変換器のことです@<endnote>{builder}。

//endnote[builder][HTML, LaTeX, TOP, IDGXMLを主要なビルダとしています。]

==== 注
//printendnotes
```

`//printendnotes` は同一 re ファイル内に記述する必要があります。つまり、章単位で後注を出力することはできますが、書籍全体で最後に1つの後注を出力する、ということはできません。

また、後注は一覧を出力するのみで見出しは付けないので、上記の例のように必要に応じて見出し、あるいは `//blankline` などで空行を入れる、といった表現をとることになります。
## Ruby 3.1 でエラーが発生するようになりました

Ruby 3.1 で YAML ライブラリ (Psych) が変更されたことにより、Re:VIEW 5.3.0 以前ではエラーが発生するようになりました。

Re:VIEW 5.4.0 以降では修正済みです。

Ruby 3.1 以上でかつ Re:VIEW 5.3.0 以下でどうしても利用する必要があるときには、下記の差分を参考に Re:VIEW のプログラムを変更してください。

- [https://github.com/kmuto/review/pull/1767/commits/16c4e5ff997db781564d6a3756abc189326326d2](https://github.com/kmuto/review/pull/1767/commits/16c4e5ff997db781564d6a3756abc189326326d2)

## Re:VIEW は Log4j のセキュリティ侵害の影響を受けますか？

Re:VIEW 自体は Apache Log4j を利用していません。

## Re:VIEW のセキュリティは堅牢ですか？

Re:VIEW はユーザー自身がシェル権限を保有して操作・実行することを想定しており、ユーザーの権限で可能なことはすべて実行可能です。LaTeX などの外部ツールとの連携のほか、preproc、フック、レイアウト erb、`//graph` など、利便性のためにコンパイル実行時に任意のシェルコマンドを注入できるものが多くあり、これらを塞ぐのは実用性を損ねるだけで非現実的です。

信頼できない第三者に Re:VIEW のコンパイル環境を提供する（CI など）場合は、重要なシステム上に直接構築せず、Docker などを使ってコンテナ化・揮発化する環境で提供し、CPU やメモリ・ネットワークなどのリソースも制限するようにしたほうがよいでしょう。第三者にシェル権限やリポジトリを提供している状況下においては、Re:VIEW のセキュリティは脆弱と言えます（そのような状況ではすでに Re:VIEW に限りませんが）。

ただ Re:VIEW 自体がネットワークを利用するのは、`review-init --wizard` で初期設定ウィザードモードを起動しているときのみなので、Re:VIEW をローカルで使用している範囲において外部からの攻撃に使われる可能性は極めて低いでしょう。

## コラム内で見出しを入れたところ、地の文の続きで採番されてしまいます

コラム内で採番レベル範囲（config.yml の secnolevel）の見出しを使うと、地の文からの継続で採番されてしまいます。コラム内で見出しを使いたいときには、採番レベルよりも大きなレベルの見出し（たとえば secnolevel が 3 であれば、`====` や `=====`）を使うことを推奨します。

書籍の都合上どうしても採番レベルが大きくなければならず、かつコラム内見出しも必要となる場合は、場当たり的ではありますが、対処としては採番を付けない nonum 見出しを利用し、かつすぐにその nonum 見出しを閉じることで、採番のない見出しをコラム内に含めることができます。

```
===[column] コラム見出し

〜

====[nonum] コラム小見出し
====[/nonum]

〜

===[/column]
```
