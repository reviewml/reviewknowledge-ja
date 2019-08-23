2019/8/23 by @kmuto

# TeX 実行時のエラーを読み解く

Re:VIEW から TeX 経由の PDF 生成の途中でエラーが発生したときの、原因の調べ方を説明します。

----

## TeX 実行の流れ

最初に、Re:VIEW から TeX 経由で PDF を生成するときに、どういうプロセスになっているのかを理解しておく必要があります。デフォルトでは以下のような流れです。

1. 作業用一時フォルダが生成される。これはシステムのテンポラリフォルダにランダムな名前で作成されて途中でエラーがあっても必ず最後に消されてしまうが、 config.yml で `debug: true` にしていた場合はプロジェクトフォルダ内に `<booknameの名前>-pdf` という名前で作られ、消されない。
2. re ファイルが逐次 .tex 拡張子の LaTeX ファイルに変換され、一時フォルダ内に置かれる。
3. 各 .tex ファイルをとりまとめる `__REVIEW_BOOK__.tex` が置かれ、さらにプロジェクトフォルダの sty サブフォルダの中身、および images フォルダの図版ファイル群が一時フォルダ内にコピーされる。
4. images フォルダの図版ファイル群に対して `extractbb` コマンド (見つからなければ `ebb` コマンド) が実行され、ファイルの縦横サイズが .xbb ファイルに記録される。
5. `__REVIEW_BOOK__.tex` ファイルに対して config.yml の `texcommand` と `texoptions` を合体させたコマンドが実行される。つまり、`uplatex -interaction=nonstopmode -file-line-error __REVIEW_BOOK__.tex` が実行される。これで、`__REVIEW_BOOK__.dvi` というファイルができる。
6. 相互参照や目次などの解決のため、5.は3回繰り返し実行される。
7. `__REVIEW_BOOK__.dvi` ファイルに対して `dvicommand` と `dvioptions` を合体させたコマンドが実行される。つまり、`dvipdfmx -d 5 -z 9 __REVIEW_BOOK__.dvi` が実行される。これで、`__REVIEW_BOOK__.pdf` というファイルができる。
8. 一時フォルダ内の `__REVIEW_BOOK__.pdf` ファイルを、プロジェクトフォルダに `<booknameの名前>.pdf` という名前でコピーする。
9. `debug: true` でない場合は一時フォルダを消去する。

.re→.tex 変換 (ステップ2.) は Re:VIEW の管轄なので、ここで文法エラーであったり図版ファイルが不足していたりなどの明確な問題を発見したときには Re:VIEW のレベルでエラーが発生し、re ファイルの行番号も添えられるので簡単に解決できるはずです。

これに対し、5.〜7. の時点でエラーが発生したときには、すでに Re:VIEW の手を離れています。

- マクロの解釈およびページ組み立ては uplatex の段階です。
- フォントの実際の埋め込みは、dvipdfmx の段階です。
- 図版ファイルの変換 (eps→PDF など) および実際の埋め込みは、dvipdfmx の段階です。

なお、rake コマンドを使っている場合は最後に `(See full trace by running task with --trace)` と表示されることがありますが、これは rake ルールの解析目的のオプションなので、Re:VIEW の実行処理の解析の役には立ちません。

## エラーの確認
### .re→.tex 変換の段階 (上記ステップ2.〜4.)
前述したように、.re→.tex変換中のエラーについては Re:VIEW が返答するので、エラーの確認は容易です。

ファイルのコピーや `extractbb` の実行についてもエラーメッセージから判断できるでしょう（パーミッションの問題や、実行コマンドがパスに存在しないなど）。

### dvi→PDF 変換の段階（ステップ7.）
dvipdfmx でありがちなのは、フォントの設定 (フォントが実際に TeX が探せる場所に存在しないか、`mktexlsr` コマンドの実行忘れで更新されていない、絵文字など対応外の文字を使っているなど) か、画像変換 (フォントの埋め込まれていない日本語 eps 図版があり、PDF 変換に使う Ghostscript が対応していないなど) に関係するエラーです。

- [Re:VIEW 向け日本語 TeX Live 環境のセットアップ（Linux、macOS、Windows）](install-tl.html)

dvipdfmx は一番最後のプロセスなので、エラー時の画面出力からおおむね判断できるはずです。

### TeX コンパイルの段階（ステップ5.）
そして、本記事の主眼であり、最もわかりにくいであろうものが、TeX コンパイル段階でのエラーです。

原因究明のとっかかりとしては、次のような設定をしてみるとよいでしょう。

- `debug: true` にする。エラー時には行番号が示されることがありますが、これは re ファイルではなく変換された .tex ファイルについての行番号なので、解析のために一時作業フォルダを消さずに保持するようにしておきます。
- `-halt-on-error` を加える。Re:VIEW 3.3 以降からはデフォルトのオプションになりますが、それより前の Re:VIEW バージョンを使っているときには、config.yml の `texoptions` を `texoptions: "-interaction=nonstopmode -file-line-error -halt-on-error"` とします（行頭の `#` も取ります）。これにより、TeX コンパイル時にエラーが発生したらその時点で実行を打ち切り、すぐに終了することで、エラーメッセージがスクロールで流れることなく確認できます。

## TeX コンパイルエラーの読み方と試行錯誤
上記の設定をした上での TeX コンパイル時のエラーは、次のような形で表示されます。

```
./foo.tex:5: Extra }, or forgotten $.
l.5 \frac{1}{2}}
                
Output written on __REVIEW_BOOK__.dvi (2 pages, 2328 bytes).
Transcript written on __REVIEW_BOOK__.log.

rake aborted!
Command failed with status (1): [review-pdfmaker config.yml...]
lib/tasks/review.rake:103:in `block in <top (required)>'
Tasks: TOP => pdf => book.pdf
(See full trace by running task with --trace)
```

`./foo.tex:5: Extra }, or forgotten $.` が停止に至ったエラーの理由表示で、この場合は `foo.tex` の 5 行目で「`Extra }, or forgotten $.`」なるエラーになったことがわかります。その後に実際の 5 行目の内容が示されています。

`debug: true` にしていれば、プロジェクトフォルダ内に `<booknameの名前>-pdf` の一時作業フォルダ（特に設定した覚えがなければ `book-pdf`）が残っており、その中の `foo.tex` を調べることができます（以下の行番号は便宜的に付けたものです）。

```
1: \chapter{数式の誤り}
2: \label{chap:foo}
3: 
4: \begin{equation*}
5: \frac{1}{2}}
6: \end{equation*}
```

re ファイルを直して再度 `rake pdf` を実行して、でももちろんよいのですが、問題のケースによってはこのような .tex ファイルを直接編集してコンパイルが通るよう試行錯誤しなければならないこともあります。

ここではエラーメッセージのとおり、`}` が1つ多いのが原因なので、5行目の末尾から `}` を1つ削除して通るかどうか試してみます。

```
5: \frac{1}{2}
```

コンパイルしてみます。

```
$ uplatex -interaction=nonstopmode -file-line-error -halt-on-error __REVIEW_BOOK__.tex
 …
Output written on __REVIEW_BOOK__.dvi (5 pages, 5340 bytes).
Transcript written on __REVIEW_BOOK__.log.
$
```

今度はエラーが起きませんでした。元々の re ファイルにちゃんと修正を反映しましょう。

dvi だけでなく、PDF の生成もしてプレビューを確認したければ、次のように実行します。

```
$ dvipdfmx -d 5 -z 9 __REVIEW_BOOK__.dvi
```

これで、`__REVIEW_BOOK__.pdf` ができます。

## 検査範囲の絞り込み
`{ }` の対応関係ミスや、利用しているマクロのエラーの場合は、エラー報告された行とは別のところが原因なこともままあります。

.tex ファイル内の途中に `\endinput` を入れると、そこで入力を打ち切り、次のファイルの読み込みに移ります。これを使って、問題の箇所を絞り込むことができます。たとえば次のようにした場合、ブロック3以降はコンパイル対象から外されます。

```
(…ブロック1…)

(…ブロック2…)

\endinput

(…ブロック3…)
```

また、時間がかかるので章単位で削っておきたいというときは、catalog.yml でコメントアウトしておくという方法もありますが、コメントアウトしたところへの相互参照があると Re:VIEW の変換時点でエラーになってしまうという問題があります。

`__REVIEW_BOOK__.tex` の `\input{foo.tex}` となっている箇所を `\include{foo}` （.tex も付けない）のように置換し、`\begin{document}` の前で `\includeonly{foo}` のようにすると、`foo.tex` だけを取り込むようになります（複数指定したい場合は `\includeonly{foo,bar}` のように `,` で区切ります）。

`\include` は強制改ページが発生するなどの副作用がいくらかあるために Re:VIEW では採用していないのですが、問題調査のときには便利でしょう。

## Re:VIEW でありがちな TeX エラー
Re:VIEW から TeX に変換するという手順では、おかしな TeX マクロを書き出したり、エスケープすべき文字をエスケープし忘れたり、といったことはあまり起きません。そのため、review-jsbook などの十分に枯れたテンプレート（クラス・スタイルファイル）を使っていて、カスタマイズも特にしていないという状況において、出現するエラーはある程度限られたものになるはずです。

### 制御文字の混入
```
foo.tex:4: Package inputenc Error: Unicode character ^^H (U+0008)
l.4 ほげほ^^H
               げほげほげ
```

Visual Studio Code などで執筆・編集中に、何かの拍子で制御文字が入ってしまうことがあるようです。re ファイルに入ってしまっている制御文字を削除してください。

### コラム内の図表
```
[1]

./__REVIEW_BOOK__.tex:134: LaTeX Error: Float(s) lost.
```

現時点の Re:VIEW のデフォルト構成においては、コラムに ID・キャプション付きの表を入れると、このようなエラーになります。コラムという囲まれた要素の中にフロート配置（.tex ファイル上で書いた位置を無視して独立して版面の上や下に置くことができる）をしようとしたためです。

`sty/review-style.sty` の末尾のほうにある `\floatplacement{table}{htp}` を `\floatplacement{table}{H}` と変えることで、表は書いたとおりの箇所に配置されるようになり、コラム内でも問題なく利用できます。

図のほうはもともと `\floatplacement{figure}{H}` と定義しており、この問題はデフォルトの設定から変えなければ問題ありません。

- [図表のフロートを制御する](control-flow.html)
- ★次メジャーバージョンでは後方互換性捨ててHにしてしまってもいいような気はしてきている

### コラム内の脚注テキスト
```
foo.tex:647: LaTeX Error: Counter too large.

See the LaTeX manual or LaTeX Companion for explanation.
Type  H <return>  for immediate help.
 ...                                              
                                                  
l.647 ...otetext[28]{\url{https://reviewml.org/}}
```

このエラーは Re:VIEW のデフォルト構成では通常見ることはありませんが、以下のような状況において発生します。

- techbooster のテンプレートのように、コラムに tcolorbox 環境を使っている
- かつ、コラムブロックの中で脚注を使っている
- かつ、コラムのブロックの「中」に `//footnote` も含んでいる

Re:VIEW 3 からはコラムや図・キャプションなどに入っている脚注をできるだけ正しく出力できるようにしています（古い Re:VIEW バージョンでは、脚注を入れたつもりでも TeX の処理の都合で出力に含まれないというケースがよくありました）。

ただ、コラムに tcolorbox 環境を使っている場合は、`//footnote` がコラムブロックの「中」にあるか「外」にあるかで挙動がまったく変わってしまいます。

対策を先に言うと、コラムの脚注の `//footnote` は、`==[/column]` のようなそのコラムの終了見出しの「後ろ」に置くべきです。

```
本文@<fn>{foo}

//footnote[foo][本文の脚注内容]

==[column] コラム
ほげほげ@<fn>{bar}

//footnote[bar][コラムの脚注内容] ←×

==[/column]

//footnote[bar][コラムの脚注内容] ←○
```

技術的な説明は以下のとおりです。

- 通常の脚注は `@<fn>` と `//footnote` の情報をもとに `\footnote{脚注内容}` というマクロにして `@<fn>` の箇所に置きます。
- これに対し、コラムなどの「処理的に厄介」な脚注は、`@<fn>` を `\footnotemark`、`//footnote` を `\footnotetext[脚注番号]{脚注内容}` というマクロにします。
- 標準の framed 環境であれば `\footnotetext` は環境の中にあろうが外にあろうが問題ありません。普通に本文から継続した番号で、アラビア数字でカウントされます（上記の例では foo は注1、bar は注2）。
- これに対し、tcolorbox 環境では、`\footnotetext` は環境の内外で挙動が違います。環境の外にある場合（上記の例では○）は、本文から継続した番号で、アラビア数字でカウントされます（上記の例では foo は注1、bar は注2）。しかし、環境の中にある場合（上記の例では×）は、本文から継続した番号ではあるのですが、何も設定しない限り a, b, cとしてカウントされます。コラム単位でカウントがリセットされるなら（EPUB とは違う結果になるにせよ）まだましなのですが、悪いことに脚注の番号は本文から継続しているので、上記の例で言えば foo は注1、bar は注bになります。また、脚注は紙面下部ではなく、コラムの囲みの末尾に入ります。
- aから始まる番号表現ではz（27）までしか利用できないので、脚注番号の値が28以上になった状態でコラム内に `\footnotetext` があると「Counter too large.」というエラーが起きます。

- [review#1379](https://github.com/kmuto/review/issues/1379)

### 数式の記述ミス
`//texequation`、`@<m>` の数式命令や、`//embed`、`@<embed>` のような生データ命令は、Re:VIEW の文法チェックの範囲外なので、誤った記述は TeX のコンパイルエラーや異常な結果に直結します。

数式でありがちなのは、`{` か `}` の指定漏れや過多で囲みの数が合わないことによるエラーです。

閉じ側が多い（または開き側が少ない）とき（`\frac{1}{2}}` として `}` が1つ多い）はまだわかりやすいのですが、

```
./math.tex:5: Extra }, or forgotten $.
l.5 \frac{1}{2}}
```

開き側が多いとき（`{\frac{1}{2}` として `{` が1つ多い）は、後続行になって初めてエラーになるため、わかりにくくなります。

```
./math.tex:6: You can't use `\eqno' in math mode.
\endmathdisplay@a ...\df@tag \@empty \else \veqno 
                                                  \alt@tag \df@tag \fi \ifx ...
l.6 \end{equation}
```

逆に、閉じ側が少ないとき（`{\frac{1}{2` として末尾の `}` が不足）は、ヒントっぽいものはあるものの、エラー行は全然違うところになります。

```
./__REVIEW_BOOK__.tex:119: File ended while scanning use of \frac .
<inserted text> 
                \par 
l.119 \reviewchapterfiles
```

数式や embed によるエラーは多岐にわたり、また Re:VIEW の範疇を超えるので、TeX Wiki のエラーメッセージについての説明などを参照してください。

- [TeXのエラーメッセージ](https://texwiki.texjp.org/?TeX%20のエラーメッセージ)
- [LaTeXのエラーメッセージ](https://texwiki.texjp.org/?LaTeX%20のエラーメッセージ)

### マクロの不具合
sty フォルダのクラスファイルやスタイルファイルに定義されたマクロに問題があるケースも、もちろんあります。Re:VIEW に添付されているものは、既知の問題で新しいバージョンでは修正済みかもしれません。

また、サードパーティから配布されるような Re:VIEW の古いバージョンに基づくクラス・スタイルファイルを使っている場合、Re:VIEW 側の変換するマクロ名や記述などの変更で互換性がなくなっている可能性もあります。

`Illegal parameter number in definition of...` や `Missing control sequence inserted.`、`Undefined control sequence.`、`Illegal unit of measure (pt inserted).
`、`Missing number, treated as zero.` などのエラーが出たときにはそのような可能性があります。

Re:VIEW の新しいリリースバージョンで、サードパーティのクラス・スタイルファイルを使っていないのにこのようなエラーに遭遇したときには、Re:VIEW のクラス・スタイルファイルの不具合と思われますので、[GitHub issues](https://github.com/kmuto/review/issues) または Twitter @kmuto までご報告ください。

## 文字が落ちる
エラーは出ないものの、PDF を作ってみると特定の文字が消失している、という現象があるかもしれません。文字が消えた箇所については、`debug: true` の状態で一度実行して一時作業フォルダを吐き出しておき、その中で `dvipdfmx __REVIEW_BOOK__.dvi` を実行してみると、「Tried to set a nonexistent character in a virtual font」というメッセージが出ているでしょう。

デフォルトで使用している upLaTeX は Unicode 範囲の文字を扱えるようになっていますが、Unicode のすべての文字を受け入れて出力できるというわけではありません。

どのような文字を出そうとしているかによって、`\CID` でフォント内のキャラクタ ID から呼び出す、専用のマクロを使う、画像化して `@<icon>` などで入れる、など対応はさまざまです。

最近流行りの絵文字も文字欠落の代表的な例です。Re:VIEW での絵文字の利用方法については、記事を改めて説明したいと思います。

- [upTeXでUnicodeできない話](https://zrbabbler.hatenablog.com/entry/20150803/1438617651])
