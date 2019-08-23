2019/8/23 by @kmuto

# TeX 実行時のエラーを読み解く

Re:VIEW から TeX 経由の PDF 生成の途中でエラーが発生したときの、原因の調べ方を説明します。

★まだだいぶ書きかけです

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

## トライアンドエラー
エラーの出ている .tex ファイルを確認する

すぐにわかれば .re ファイル側を直す

よくわからなければ、.tex ファイルを調査。
`{ }` の対応関係ミスや、利用しているマクロのエラーの場合、エラー報告された行とは別のところが理由なこともよくある。

一時作業フォルダ内で .tex ファイルの怪しそうなところの行頭に `%` を付けてコメントアウトし、 `uplatex -interaction=nonstopmode -file-line-error -halt-on-error __REVIEW_BOOK__.tex` を手動で実行してみる

`__REVIEW_BOOK__.log`
`\endinput`

catalog.yml を別名で作り（たとえば catalog-debug.yml）、config.yml で指定

```
catalogfile: catalog-debug.yml
```

## ありがちなエラー

float


### コラム内の取り扱い
footnote
outer
〜.tex:647: LaTeX Error: Counter too large. ←これがエラー

//footnoteをcolumnの外に

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

### スタイルファイルの不具合



## 文字が落ちる
エラーは出ないものの、PDF を作ってみると特定の文字が消失している、という現象があるかもしれません。特に最近流行りの絵文字は使いたい方も多いでしょうが、ほとんどの場合、その文字は消えてしまっているはずです。

文字が消えた箇所については、`debug: true` の状態で一度実行して一時作業フォルダを吐き出しておき、その中で `dvipdfmx __REVIEW_BOOK__.dvi` を実行してみると、「Tried to set a nonexistent character in a virtual font」というメッセージが出ているでしょう。

デフォルトで使用している upLaTeX は Unicode 範囲の文字を扱えるようになっていますが、Unicode のすべての文字を受け入れて出力できるというわけではありません。

★絵文字について対策などをFAQか別記事に入れる

- [upTeXでUnicodeできない話](https://zrbabbler.hatenablog.com/entry/20150803/1438617651])
