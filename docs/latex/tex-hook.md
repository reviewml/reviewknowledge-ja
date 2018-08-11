2018/8/11 by @kmuto

# フックで LaTeX 処理に割り込む

review-pdfmaker での PDF 生成は複数の段階からなりますが、フックを使って途中で割り込み、紙面を調整できます。

★キャプチャを入れたい

----

## フックのタイミング
review-pdfmaker を実行すると、以下のように内部で処理が進みます。

1. 作業用の一時フォルダが生成される。
2. latex ビルダで reファイルから LaTeX ファイル（拡張子 `.tex`）に変換し、一時フォルダに配置する。
3. プロジェクトフォルダの sty サブフォルダの内容や、images サブフォルダが一時フォルダにコピーされる。
4. システムまたはプロジェクトフォルダの layouts サブフォルダにあるレイアウトファイル `layout.tex.erb` が評価された後、一時フォルダに `__REVIEW_BOOK__.tex`（Re:VIEW 3 以上）または `book.tex`（Re:VIEW 2以前）という名前で配置される。
5. 一時フォルダ内に移動する。
6. **hook_beforetexcompile パラメータにプログラムが指定されていればそれを実行する。**
7. LaTeX コンパイラを 2 回実行する（LaTeX は複数回のコンパイルで紙面を完成させる仕組み）。
8. **hook_beforemakeindex パラメータにプログラムが指定されていればそれを実行する。**
9. 索引処理を有効にしているなら索引プログラムを実行する。
10. **hook_aftermakeindex パラメータにプログラムが指定されていればそれを実行する。**
11. LaTeX コンパイラを 1 回実行する。
12. **hook_aftertexcompile パラメータにプログラムが指定されていればそれを実行する。**
13. dvi ファイルが生成されていれば dvi から PDF に変換するプログラムを実行する。
14. **hook_afterdvipdf パラメータにプログラムが指定されていればそれを実行する。**

15. PDF ファイル `__REVIEW_BOOK__.pdf` または `book.pdf` を、bookname パラメータで指定した本来の名前にしてプロジェクトフォルダに配置する。
16. 一時フォルダを消去する。

太字で示した箇所がフック処理の箇所です。config.yml で pdfmaker の下位設定として定義します。

```
 …
pdfmaker:
  hook_beforetexcompile: プログラムのパス
 …
```

フックは、それぞれ以下のような用途を想定しています。

- hook_beforetexcompile：re ファイルから変換された tex ファイルを加工する。デフォルトでコピーされるものに加えて、さらにファイルをコピーする。
- hook_beforemakeindex：索引を有効にしている場合、索引情報ファイル `__REVIEW_BOOK__.idx` または `book.idx` が生成されるので、これを索引ツールに渡す前に加工する。
- hook_aftermakeindex：索引を有効にしている場合、索引ツールを経て索引 TeX ファイル `__REVIEW_BOOK__.ind` または `book.ind` が生成されるので、これを LaTeX コンパイラに渡す前に加工する。
- hook_aftertexcompile：目次を加工するなど、最終段階の状態にさらに処理を加える。
- hook_afterdvipdf：PDF をさらに加工する（グレースケール化する、別の PDF と合体させるなど）。

## フックプログラムの構成

フックのパラメータに指定するプログラムは、実行形式になっていれば何でもかまいません。プログラムには、その呼び出し時に引数が2つ渡されます。

- 引数1：一時フォルダのパス
- 引数2：プロジェクトフォルダのパス

引数を受けて処理するフックプログラムは、通常は Ruby スクリプトあるいはシェルスクリプトで書くのが簡単でしょう。たとえば以下のようになります。

```
#!/usr/bin/env ruby
File.write("#{ARGV[1]}/hook.log",
           "一時フォルダのパス：#{ARGV[0]}\n" +
           "プロジェクトフォルダのパス：#{ARGV[1]}\n")
```

ファイルには実行形式属性（`chmod +x`）を付けておく必要があります。実行形式属性がないと、単に無視されて実行されません。

上記のプログラムコードをプロジェクトフォルダに hook_beforetexcompile.rb という名前で置き、config.yml で以下のように指定します。

```
 …
pdfmaker:
  hook_beforetexcompile: hook_beforetexcompile.rb
 …
```

`rake pdf` を実行すると、TeX のコンパイル直前にフックが動き、この例の場合はプロジェクトフォルダに hook.log というファイルができます。

```
一時フォルダのパス：/tmp/book-pdf-20180811-31959-1m19hdf
プロジェクトフォルダのパス：/home/kmuto/review-samples/test
```

★Windows Dockerだとパーミッションはどう見える？

★Windowsネイティブだとスクリプト起動ができないのでruby.exeを指定する必要だが、hookパラメータはオプションまでの指定はできない構造。バッチファイルを呼ぶようにしてそこで引数解析してruby.exe+スクリプトに渡す、といった対処が必要になると予想。

## デバッグモード
config.yml でデバッグモードにすると、プロジェクトフォルダに「booknameの値-pdf」が作られ、そこが一時フォルダとなります。デバッグモードでは、この一時フォルダは消去されません。

```
debug: true
```

フックによる変更がうまくできているかどうかを確認するため、最初はデバッグモードにしておくとよいでしょう。

デバッグモードでないときには、一時フォルダはプロジェクトフォルダとは異なるフォルダ（たとえば /tmp 内）に作られることに注意してください。

## フックの例

以下では、フックを使った「長い文字列の折り返し」の例をいくつか示します。

### 見出しの折り返し

見出しが長いときには版面に合わせて自動で折り返されますが、人間が見たときにより妥当な位置で折り返したいことがあります。たとえば ch1.re からの生成結果が以下のようになっていたとします。

```
1.5　サーバーとクライア
     ント

↓ 理想

1.5　サーバーと
     クライアント
```

[見栄えが悪い箇所を「少しだけ」調整する](modify-abit.html) では段落内で `@<embed>` インライン命令を使うことで `\allowbreak` を入れる例を示しましたが、見出しは目次や柱にも使われるので、TeX ファイルでの加工が必要です。

config.yml で debug パラメータを `true` にして一時フォルダの ch1.tex を見てみます。

```
 …
\section{サーバーとクライアント}
 …
```

LaTeX （のクラスファイル）では、目次や柱に使う見出しと、その場所で表現する加工した見出しを別個に指定することができます。ここでは、以下のように変えるのが目標です。`[]`内が目次や柱用の見出し、`{}`内がその場所で表現する見出しです。`\\` はそこで改行する（均等割にせず強制改行）という意味です。

```
 …
\section[サーバーとクライアント]{サーバーと\\クライアント}
 …
```

ch1.tex を加工するフックプログラム hook_beforetexcompile.rb を作成します。

```
#!/usr/bin/env ruby
File.open("#{ARGV[0]}/ch1.tex", 'r+') do |f|
  s = f.read.sub('\section{サーバーとクライアント}',
                 '\section[サーバーとクライアント]{サーバーと\\\\\クライアント}')
  f.rewind
  f.print s
end
```

短く表現するために少々トリッキーな書き換えをしていますが、要するに単純にファイル内容の文字列置換をして書き出しているだけです。重複したエスケープ表現のため、`\\` ではなく `\\\\\` とする必要があります。

実行権限を付けたら、config.yml で指定します。

```
 …
pdfmaker:
  hook_beforetexcompile: hook_beforetexcompile.rb
 …
```

これで、見出しが指定どおりに折り返されるでしょう。

★より妥当な長さの見出し例にしたい

### 目次の折り返し

config.yml で `toc: true` を指定すると目次が生成されますが、目次の内容はページ参照が含まれるので最終段階まで確定しません。そのため、 hook_aftertexcompile で調整します。

目次ファイルは `__REVIEW_BOOK_.tex` （Re:VIEW 3 以降）または `book.tex` （Re:VIEW 2 以前）として生成されています。

```
 …
\contentsline {section}{\numberline {1.5}サーバーとクライアント}{20}{section.1.5}
 …
```

「`\numberline {1.5}サーバーとクライアント`」の部分がそのまま整形（ページ参照は「20」）されて表現されるので、折り返しを調整するにはここを加工します。

また、hook_aftertexcompile の後には LaTeX のコンパイルは行われないので、フックプログラムの中でコンパイルも実行するようにします。

以下の hook_aftertexcompile.rb を作成します（Re:VIEW 2 以下の場合は `__REVIEW_BOOK__` を `book` に置き換えてください）。

```
#!/usr/bin/env ruby
File.open("#{ARGV[0]}/__REVIEW_BOOK__.toc", 'r+') do |f|
  s = f.read.sub('{1.1}サーバーとクライアント}',
                 '{1.5}サーバーと\\\\\クライアント}')
  f.rewind
  f.print s
end

system('uplatex -interaction=nonstopmode -file-line-error __REVIEW_BOOK__.tex')
```

例のごとく実行権限を付けたら、config.yml で呼び出しの設定をします。

```
 …
pdfmaker:
 …
  hook_aftertexcompile: hook_aftertexcompile.rb
 …
```

これで、目次が折り返されるようになります。

### URL の折り返し

`@<href>` 命令で指定した URL は、`\url{〜}` という LaTeX のマクロに置き換えられ、等幅コードと同じルールで表現されます。紙面の都合で途中で改行するには、その箇所の `\url{〜}` を `\href{URL}{紙面表現}` に置き換える必要があります。

ch1.tex の `\url` マクロの箇所を加工するフックプログラム hook_beforetexcompile.rb を示します。

```
#!/usr/bin/env ruby
File.open("#{ARGV[0]}/ch1.tex", 'r+') do |f|
  s = f.read.sub('\url{https://ja.wikipedia.org/wiki/マークアップ言語}',
                 '\href{https://ja.wikipedia.org/wiki/マークアップ言語}{https://ja.wikipedia.org/wiki/マー\allowbreak クアップ言語}')
  f.rewind
  f.print s
end
```

文章に変更があると改行の方針も変わる可能性があります。このような調整は、文章が確定した制作終盤に行うのがよいでしょう。
