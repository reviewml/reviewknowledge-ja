# FAQ - Re:VIEW の使い方について

FAQ（よくある質問と回答）のこのセクションは、Re:VIEW の使用方法のポインタや、使う上での注意点などをまとめています。

----

## Re:VIEW を動かすにはどのような環境が必要ですか？

Ruby インタプリタ 2.1 以上がインストールされた OS 環境であれば、基本的に動作します。TeX を使った PDF 生成を行う場合は、別途日本語 TeX 環境のセットアップが必要です。

推奨環境は Linux（特に Debian GNU/Linux 安定版 または Ubuntu 安定版）、および macOS です。

Windows でも、ネイティブ環境でのセットアップ、WSL（Windows Subsystem for Linux）でのセットアップの報告があります。

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
apt-get install --no-install-recommends texlive-lang-japanese texlive-fonts-recommended texlive-latex-extra lmodern fonts-lmodern tex-gyre fonts-texgyre texlive-pictures ghostscript gsfonts zip ruby-zip ruby-nokogiri mecab ruby-mecab mecab-ipadic-utf8 poppler-data cm-super graphviz gnuplot python-blockdiag python-aafigure
```

★TODO:macOS、Windows。TeXと合わせて独立ページにしたほうがいい？

## TeX 環境の構築はどうしたらよいですか？

[FAQ - Re:VIEW の使い方について（TeX PDF）/TeX 環境の構築はどうしたらよいですか？](faq-tex.html)

## Docker のイメージはありますか？

以下でセットアップできます。

```
docker pull vvakame/review
```

利用方法などは以下を参照してください。

- [https://github.com/vvakame/docker-review](https://github.com/vvakame/docker-review)

## 基礎的なガイダンスを記した公式のドキュメントはありますか？

- [Re:VIEW Quick Start Guide](https://github.com/kmuto/review/blob/master/doc/quickstart.ja.md)
- [Re:VIEW Format Guide](https://github.com/kmuto/review/blob/master/doc/format.ja.md)
- [その他のドキュメント](https://github.com/kmuto/review/tree/master/doc)

## Re:VIEW の入門書はありませんか？

- [技術書をかこう! 〜はじめてのRe:VIEW〜 改訂版](https://techbooster.booth.pm/items/586727)（PDF・印刷書籍）

## バグを見つけました。どうしたらよいですか？

GitHub の issue ページ
[https://github.com/kmuto/review/issues](https://github.com/kmuto/review/issues)
までお寄せください（日本語または英語）。

## プロジェクト（作業フォルダ）を作るにはどうしたらよいですか？

`review-init` コマンドを使います。

```
review-init プロジェクト名
```

## プロジェクトにどのようにコンテンツを置いたらよいですか？

## re ファイルを書くのに専用のエディタは必要ですか？

re ファイルは命令を含めてすべてテキストで表現されるので、UTF-8 文字エンコーディングをサポートし、プレインテキスト形式での読み込み・書き出しが可能なテキストエディタであれば OS・ソフトウェアを問わず何でも利用できます。

ただ、Re:VIEW 固有の命令を記入したり色分け表示したりといった支援モードが提供されているエディタを使ったほうが、執筆および編集には便利でしょう。

## re ファイルでの執筆・編集を支援するエディタにはどのようなものがありますか？

## 図版はどこに置くのですか？ また、どのような形式に対応していますか？

## config.yml ファイルはどのような役目を持っていますか？

## catalog.yml ファイルはどのような役目を持っていますか？

## PDF（review-pdfmaker）と EPUB（review-epubmaker）で若干異なる設定にしたいと思います。ほぼ重複する内容の yml ファイルを作らずに済みませんか？

## 「図」「リスト」などの一部の固定文字列は locale.yml ファイルで変えられるようですが、どのように書いたらよいですか？

## EPUB に変換するにはどうしたらよいですか？

以下のようにして変換します。

```
rake epub
```

以下でも可能です（`rake epub` は中でこのコマンドを実行しています）。

```
review-epubmaker config.yml
```

## LaTeX を使った PDF に変換するにはどうしたらよいですか？

以下のようにして変換します。

```
rake pdf
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

## pandoc で Re:VIEW の書式はサポートされますか？

## LaTeX を使いたくないのですが、ほかの PDF 作成方法はありませんか？

たとえば InDesign を使う方法と、CSS 組版を使う方法があります。

- InDesign：IDGXML 形式に変換し、レイアウトデザイン向けに調整した上で、Adobe InDesign で半自動 DTP を行う。
- CSS組版：EPUB に変換し、EPUB をそのまま PDF 変換する（[VersaType Converter](https://trim-marks.com/ja/)、[EPUB to PDF変換ツール](https://www.antenna.co.jp/epub/epubtopdf.html) など）か、EPUB の HTML を結合し、Web ブラウザ上で整形したものを PDF として保存する（[Vivliostyle.js](https://vivliostyle.org/) など）

これらのいずれも困難であったり、あるいは手作業工程の DTP オペレータに引き渡すということであれば、Re:VIEW 原稿をプレインテキストに変換（`rake text`）して手作業でページを制作していくほうが妥当かもしれません。

## 表のセル区切りはなぜ空白文字ではなく「タブ1つ」なのですか？

## 表のセルを連結するにはどうしたらよいですか？

## 別フォルダにあるソースコードファイルの一部を原稿内に取り込みたいと思います。動的に取り込む方法はありますか？

## catalog.yml での最小単位は章単位ですが、節や項に分けることはできませんか？

## 見出しの一覧を出力することはできますか？

## Re:VIEW に対応した日本語校正ツールはありますか？

## 変換途中で独自の処理を挟むことはできますか？

## Re:VIEW の標準の命令処理を変えたり、新たな命令を追加したりすることはできますか？

`review-ext.rb` というファイルを使い、Re:VIEW のロジックを上書きできます。

- [Re:VIEW のモンキーパッチによる拡張の基本](../reviewext/review-ext-basic.html)

## 索引を入れるにはどうしたらよいですか？

## プロジェクト直下がたくさんの re ファイルだらけでごちゃごちゃしてしまいました。サブフォルダにまとめて置くことはできますか？

Re:VIEW 3.0 から、config.yml の `contentdir` パラメータを使って re ファイルを保持するサブフォルダを指定することができます。指定のサブフォルダに格納できるのは re ファイルのみで、画像はプロジェクトフォルダ直下にある images フォルダに入れることに変わりはありません。

## UML やグラフの生成ツールから動的に生成して配置することはできますか？

## インライン命令内で入れ子ができません！

Re:VIEW の言語解析ロジック上、および記法の複雑化を避けるため、インライン命令は入れ子にすることはできません。

複合した結果になる新たな命令を `review-ext.rb` で定義する必要があるかもしれません。

## インライン命令内で「}」を文字として表現したいときにはどうしたらよいですか？

## インライン命令内の最後で「\」を文字として表現したいときにはどうしたらよいですか？

## @\<m\>命令を使って TeX 式を記述したところ、「}」がたくさん登場して都度「\}」とするのが大変です。何か対策はありますか？

## Re:VIEW は夏時間に対応していますか？

Ruby ライブラリおよび OS の対応範囲での対応となります。実際のところ、Re:VIEW の実装で「現在時刻」に基づく処理が発生するのは、以下の2箇所のみです。

- review-init 実行時に config.yml ファイルに書き出す、date: および history: のパラメータの日付の生成
- review-epubmaker 実行時に OPF メタファイルに書き出される modified タイムスタンプの生成（バージョン 2.5 まではローカルタイム（ただし不適切な時差表記）、バージョン 3 以降は UTC）

前者は日付だけなので、OS の時刻が正しく設定されていれば夏時間は影響しません。後者は「Re:VIEW バージョン 2.5 までを使用し」「夏時間からの時刻の巻き戻しの前後で2回の EPUB ビルドをして」「その2つの EPUB をリーダー上で更新する」ときに「リーダーが modified タイムスタンプを見て更新の有無を判断する」場合に、更新がうまくいかないかもしれません。要するに、まず発生することはない、ということです。
