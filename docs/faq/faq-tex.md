# FAQ - Re:VIEW の使い方について（TeX PDF）

FAQ（よくある質問と回答）のこのセクションは、Re:VIEW の使用方法のうち、TeX を使った PDF 生成に関係する事柄をまとめています。

----

## TeX 環境の構築はどうしたらよいですか？
- [Re:VIEW 向け日本語 TeXLive 環境のセットアップ（Linux、macOS）](../latex/install-tl.html)

## LaTeX を使った PDF に変換するにはどうしたらよいですか？

プロジェクトフォルダで `rake pdf` を実行するか、`review-pdfmaker config.yml` を実行します。

## LaTeX 実行時でのエラーが出ましたが、どのように調べたらよいですか？

LaTeX のコンパイル実行でエラーが生じると、エラーが発生した箇所と行番号が表示されます（エラー時の出力はかなり長くなることがあり、結果をシェルのリダイレクトなどで保存したほうがよいかもしれません）。

デフォルトでは Re:VIEW の re ファイルから LaTeX テキストしたファイルは一時フォルダに置かれており、いちいちこれを参照するのは不便です。

config.yml で
```yaml
debug: true
```
とすると、デバッグモードとなり、一時フォルダの代わりにプロジェクトフォルダ内に「book-pdf」（book の部分は bookname の値に依存）のようなフォルダが作られます。このフォルダは実行後も消去されないので、ここから LaTeX テキストファイルを開き、エラーの行を参照して解析できます。

また、`review-pdfmaker --debug config.yml` のように `--debug` オプションを付けるとconfig.yml の設定に関わらず一時的にデバッグモードになります。

## LaTeX のエラーの意味がわかりません。

LaTeX でエラーが発生したときには、「!」から始まるエラーメッセージが表示されています（デバッグモードにして実行し、`__REVIEW_BOOK__.log` または `book.log` を参照するのもよいでしょう）。
[TeX Wiki](https://texwiki.texjp.org/?FrontPage#d1cf258f)の「エラーに遭遇したときは」には、代表的な TeX および LaTeX のエラーについて列挙されています。

エラーによっては、示された行でなく、その前の行に問題があることがあります。

コラムなどの囲み要素では、フロートの図表（`//image` や `//table`）に制約があります。Re:VIEW 3 以上のレイアウトでは対策していますが、古いレイアウトおよびサードパーティレイアウトでは対応していないことがあります。

Re:VIEW に起因する問題と思われる場合は issue で報告してください。サードパーティのレイアウトテンプレートを使用している場合にはそのサードパーティに連絡してください。

## LaTeX の紙面サイズを変更するにはどうしたらよいですか？

Re:VIEW 3 からは、ドキュメントクラスオプションの `paper` で紙面サイズを指定可能です。

```yaml
texdocumentclass: ["review-jsbook", "media=print,paper=a5"]
```

a5 の部分を b5 などに書き換えれば変更されます。

Re:VIEW 2 以前で jsbook ベースのレイアウトを使っている場合は、config.yml の texdocumentclass パラメータに対するオプションで指定できます（正確には、これがドキュメントクラスに直接渡されます）。

デフォルトは以下のようになっています。

```yaml
texdocumentclass: ["jsbook", "uplatex,twoside"]
```

これを A5 にするには次のようにします。

```yaml
texdocumentclass: ["jsbook", "uplatex,twoside,a5j"]
```

jsbook において文字列で指定可能な紙サイズを以下に示します。

- `a3paper`：A3（297mm x 420mm）
- `a4paper` または `a4j`：A4（210mm x 297mm）、デフォルト
- `a5paper` または `a5j`：A5（148mm x 210mm）
- `a6paper`：A6（105mm x 148mm）
- `b4paper` または `b4j`：B4（257mm x 364mm）
- `b5paper`：B5（182mm x 257mm）
- `b6paper`：B6（128mm x 182mm）
- `a4var`：A4変の一例（210mm x 283mm）
- `b5var`：B5変の一例（182mm x 230mm）
- `letterpaper`：レター（8.5in x 11in）
- `legalpaper`：リーガル（8.5in x 14in）
- `executivepaper`：エグゼクティブ（7.25in x 10.5in）

`sty/reviewmacro.sty` に mm などの単位で数値を明示することもできます。

```
\setlength\paperwidth{幅truemm}
\setlength\paperheight{高さtruemm}
```

## LaTeX の紙面レイアウトに満足がいきません。どうやったら置き換えられますか？

標準で提供されているものを変えるには LaTeX および TeX の知識が必要となります。また、場当たりな修正は後々問題になる可能性があります。本当にそのレイアウト調整がすべきことなのかどうかをまず検討したほうがよいでしょう。レイアウトに細かなこだわりを入れたいときには、わざわざ Re:VIEW を経由するよりも、コンテンツを LaTeX 記法で記述し、レイアウト指示もそれに含めるほうが妥当です。

LaTeX はマクロの集合体です。Re:VIEW から読み込まれるカスタムスタイルファイル `sty/review-custom.sty`（Re:VIEW 3 系）または `sty/reviewmacro.sty`（Re:VIEW 2 以前）にマクロを記述することで、それまでに定義されたマクロを上書きできます。

- [pLaTeX2e 新ドキュメントクラス](https://oku.edu.mie-u.ac.jp/~okumura/jsclasses/)

## LaTeX の紙面レイアウトとして他のテンプレートはありますか？

デフォルトのもの以外に広く使われているものとして、TechBooster 提供のテンプレートがあります (Re:VIEW 3 に対応しています)。

- [https://github.com/TechBooster/ReVIEW-Template](https://github.com/TechBooster/ReVIEW-Template)

## LuaTeX-ja を使うにはどうしたらよいですか？

Re:VIEW 3 以上で LuaTeX への対応を進めています。ただし、現状では LuaTeX を使うユーザーが LaTeX についての十分な知識を持っており、問題を自己解決できるだけの能力があることを前提としています。

1. config.yml の `texdocumentclass` パラメータを LuaTeX-ja のものに変更する（`texdocumentclass: ["ltjsbook", "oneside"]` など）。
2. `texcommand` パラメータを変更する。`texcommand: "lualatex"`
3. `dvicommand` パラメータを null にする（`dvicommand: null`）。これは特に重要です。単にコメントアウトするだけでは、デフォルトの upLaTeX 用の `dvicommand` パラメータ値が有効になってしまいます。
4. プロジェクトの sty フォルダのファイル群で LuaTeX-ja に対応していないところを調整する。

## トンボを付けるにはどうしたらよいですか？

Re:VIEW 3 ではデフォルト（`media=print` のとき）でトンボが付きます。Re:VIEW 2 以前の場合は下記を参照してください。

- [jsbook ベースのドキュメントにトンボおよびデジタルトンボを配置する](../latex/tex-tombow.html)

## 入稿先に PDF/X-1a 形式か PDF/X-4 形式にするよう求められました。どうしたらよいですか？

PDF/X-1a、PDF/X-4 は印刷用 PDF として準拠の求められることの多い標準規格ですが、現時点でフリーソフトウェアの範囲ではこれに明確には対応できません。たとえば以下のような有償ソフトウェアを利用して変換することを推奨します。

- Adobe 社 Acrobat：[https://acrobat.adobe.com/jp/ja/acrobat.html](https://acrobat.adobe.com/jp/ja/acrobat.html)
- callas 社 pdfToolbox：[https://www.callassoftware.com/en/products/pdftoolbox](https://www.callassoftware.com/en/products/pdftoolbox)

## 全体をグレースケールにするにはどうしたらよいですか？

LaTeX 自体（および upLaTeX からの PDF 生成に使われる dvipdfmx）にはグレースケール化の機能はありません。

一般には Acrobat または pdfToolbox を使ってグレースケール化します。ただし、Acrobat はグレースケール化によって線の太さが変わったり点線が実践になることがある問題があります。

LaTeX セットにも関連付けてインストールされるフリーソフトウェア Ghostscript を使って PDF をグレースケール化することは可能です。

```
gs -q -r600 -dNOPAUSE -sDEVICE=pdfwrite -o 出力PDF名 -dPDFSETTINGS=/prepress -dOverrideICC -sProcessColorModel=DeviceGray -sColorConversionStrategy=Gray -sColorConversionStrategyForImage=Gray -dGrayImageResolution=600 -dMonoImageResolution=600 -dColorImageResolution=600 入力PDF名
```

ただし、Ghostscript も PDF によっては内容を壊す（文字の欠落や順序の変化）ことがあります。変換後は必ず全体を照合するようにしましょう。

## コンパイルや PDF 生成処理の途中に割り込むにはどうしたらよいですか？

- [フックで LaTeX 処理に割り込む](../latex/tex-hook.html)

## 長い表がはみ出してしまうのですが、ページで分割するにはどうしたらよいですか？

## 等幅の長い文字を入れると文字の間がスカスカになってしまいます。途中で折り返させるにはどうしたらよいですか？

- [見栄えが悪い箇所を「少しだけ」調整する](../latex/modify-abit.html)

## ページの途中で強制的に改ページするにはどうしたらよいですか？

- [見栄えが悪い箇所を「少しだけ」調整する](../latex/modify-abit.html)

## あるページの版面を少しだけ伸ばすにはどうしたらよいですか？

- [見栄えが悪い箇所を「少しだけ」調整する](../latex/modify-abit.html)

## `@<tt>` や `@<code>` の等幅の箇所が段落からはみ出てしまいます。途中で折り返させるにはどうしたらよいですか？

[見栄えが悪い箇所を「少しだけ」調整する](../latex/modify-abit.html) で提示しているように、`\allowbreak` または `\linebreak` マクロを `@<embed>` 命令を使って埋め込むことを推奨します。

どうしても「自動で折り返し」をしたいときには、次のようなマクロを `sty/review-custom.sty` に追加することで、`\reviewtt` 等の挙動を変えて分割可能です。

```
\makeatletter
\newif\ifreview@ba@break
\def\review@ba@end{\review@ba@end@}
\DeclareRobustCommand{\reviewbreakall}[1]{%
  \begingroup
    \review@ba@breakfalse
    \review@break@all@a#1\review@ba@end
  \endgroup
}
\def\review@break@all@a{%
  \futurelet\review@ba@tok\review@break@all@b
}
\def\review@break@all@b{%
  \ifx\review@ba@tok\review@ba@end
    \let\next\@gobble
  \else\ifx\review@ba@tok\@sptoken
    \let\next\review@break@all@c
  \else\ifx\review@ba@tok~%
    \let\next\review@break@all@d
  \else\ifx\review@ba@tok\bgroup
    \let\next\review@break@all@e
  \else
    \let\next\review@break@all@f
  \fi\fi\fi\fi
  \next
}
\expandafter\def\expandafter\review@break@all@c\space{%
  \space
  \review@ba@breakfalse
  \review@break@all@a
}
\def\review@break@all@d#1{%
  \review@break@all@f{\mbox{\space}}%
}
\def\review@break@all@e#1{%
  \review@break@all@f{{#1}}%
}
\def\review@break@all@f#1{%
  \ifreview@ba@break
    \hskip0pt plus 0.02em\relax
  \fi
  #1%
  \review@ba@breaktrue
  \review@break@all@a
}

\DeclareRobustCommand{\reviewtt}[1]{{\ttfamily\reviewbreakall{#1}}}
\DeclareRobustCommand{\reviewcode}[1]{{\ttfamily\reviewbreakall{#1}}}
\DeclareRobustCommand{\reviewtti}[1]{{\ttfamily\itshape\reviewbreakall{#1}}}
\DeclareRobustCommand{\reviewttb}[1]{{\ttfamily\bfseries\reviewbreakall{#1}}}
\makeatother
```

## 複数のスペース文字を入れても、1つになってしまいます。どうしたらよいですか？

どうしてもリテラルなスペースを入れたいときには、以下のようにして埋め込みます。

```
3つのスペースを@<embed>{|latex|~~~}@<embed>{|html|&nbsp;&nbsp;&nbsp;}と入れる
```

- ★PR #1278
- 等幅インライン命令での参考 https://gist.github.com/kmuto/4446c219a12d1ac676dd95c9da4b9e65

## PREDEF、POSTDEF で割り当てたファイルで図表を使うと、おかしな番号の振り方になります。

- [前付（PREDEF）、後付（POSTDEF）の図表採番を本章同様にリセットする](../latex/prepost-num.html)

## jsbook ベースのテンプレートで、ページを頭からの通し番号にするにはどうしたらよいですか？

Re:VIEW 3 以降では、`serial_pagination=true` ドキュメントクラスオプションで通し番号になります。

Re:VIEW 2 以前の場合、jsbook.cls では以下の2箇所で暗黙にページ番号を変えているため、マクロを上書きする必要があります。

- titlepage（大扉などで利用）でページ番号を0にリセット
- 前付（frontmatter）でローマ数字、本文（mainmatter）でアラビア数字化。それぞれ `pagenumbering` マクロを使用しており、このマクロで番号は0にリセットされる

単純に頭からの通し番号にするには、`sty/reviewmacro.sty`に次のように書いて jsbook.cls のマクロを上書きします。

```
\renewenvironment{titlepage}{%
    \cleardoublepage
    \if@twocolumn
      \@restonecoltrue\onecolumn
    \else
      \@restonecolfalse\newpage
    \fi
    \thispagestyle{empty}%
%    \setcounter{page}\@ne% リセットを無効化
  }%
  {\if@restonecol\twocolumn \else \newpage \fi
    \if@twoside\else
%      \setcounter{page}\@ne% リセットを無効化
    \fi}
\renewcommand\pagenumbering[1]{% デフォルトのアラビア文字のみとして何もしない
}
```

## 開始ページ番号を変えるにはどうしたらよいですか？

Re:VIEW 3 以降では、ドキュメントクラスオプション `startpage=開始ページ番号` で大扉の開始ページ番号を指定できます。

## 目次を付けるにはどうしたらよいですか？

config.yml の toc パラメータを true にします。

```yaml
toc: true
```

または

```yaml
pdfmaker:
  toc: true
```

## 目次などでリンクに色や囲みが付きます。装飾なしの黒にできませんか？

Re:VIEW 2 系のデフォルトのスタイルなどでは、この状況になります（Re:VIEW 3 以降ではデフォルトでリンクに色や囲みを使わないようにしています）。

`sty/reviewmacro.sty` に以下のように追加することで、リンクを表す表現を取り下げます。

```
\hypersetup{hidelinks}
```

## 表紙を全面に貼り付けるにはどうしたらよいですか？

Re:VIEW 3 以降ではデフォルトで全面貼り付けになっています。

Re:VIEW 2 系では全面に貼り付ける命令をまだ用意していないため、命令の追加および表紙部分の LaTeX ソースを置き換えることで対処します。

表紙の画像ファイルを用意しておきます（実寸・PDF 形式を推奨します）。ここでは `images/cover.pdf` に入れておくとします。

全面貼り付けを提供する LaTeX マクロを `sty/reviewmacro.sty` に追加します。

```
\newcommand*\includecover[2][]{%
 \clearpage
 \thispagestyle{empty}%
\vbox to \textheight{%
  \vskip-\dimexpr\headheight + 1in\relax%
  \vbox to \paperheight{\vss%
    \hbox to \textwidth{%
      \hskip-\dimexpr\oddsidemargin + 1in\relax%
      \hbox to \paperwidth{\hss
        \includegraphics[#1]{#2}%
        \hss}%
    \hss}%
  \vss}%
\vss}%
}
```

表紙部分を差し替える LaTeX 断片ファイルを作成します。ここでは `cover.tex` という名前でプロジェクトフォルダに置いておくことにします。

```
\includecover[width=\paperwidth,height=\paperheight]{images/cover.pdf}
```

この `cover.tex` を使うよう、`config.yml` を設定します。

```
pdfmaker:
  cover: cover.tex
```

これで、表紙が全面貼り付けになります。定義したマクロ自体は、re ファイル内でも embed 命令を使って普通の紙面内に使うことができます。

```
//embed[latex]{
\includecover{images/sashie.pdf}
//}
```

## 挿絵を全面に入れるにはどうしたらよいですか？

Re:VIEW 3 の場合、`\includefullpagegraphics` 命令を利用できます。

```
//embed[latex]{
\includefullpagegraphics{images/sashie.pdf}
//}
```

画像ファイルは実寸で、中央合わせで配置されます。塗り足し領域がある場合にはそれを含めたサイズで用意します。

Re:VIEW 2 の場合は上記の `\includecover` を使ってみるとよいでしょう。

## Illustrator AI ファイルを配置したところ、何かおかしいです

厳密には、TeX（というよりは dvi ウェア）は Illustrator のネイティブ形式である AI ファイルをサポートしているというわけではなく、「PDF 互換ファイル」オプション付きで保存された AI ファイルの PDF 部分を使用しています。このオプションなしで保存されている AI ファイルは表示できないので、Illustrator でオプションを有効にして再保存する必要があります。

また、Illustrator 上でレイヤーをオフにして非表示にしていても、TeX に貼り付けた場合には表示されてしまうため、事前に表示不要なレイヤーを削除しておく必要があります。

## Photoshop psd ファイルを配置できません

2018年11月時点では、Photoshop のネイティブ形式である psd ファイルはサポートされていません。

ただし、graphicxpsd パッケージを使うと、sips（macOS のツール）または covert（ImageMagick）を使用して、コンパイル時に psd ファイルを PDF に変換して利用できます。graphicxpsd パッケージは TeXLive 2017 以降に収録されているほか、`tlmgr install graphicxpsd` でインストールすることもできます。

sty/review-custom.sty でスタイルファイルを読み込むよう設定します。

```
\usepackage{graphicxpsd}
```

外部コマンド実行を許容するため、config.yml の texoptions に `--shell-escape` を追加します。

```
texoptions: "-interaction=nonstopmode -file-line-error --shell-escape"
```

## 隠しノンブルを入れるにはどうしたらよいですか？

同人誌印刷では、全ページにページ番号を入れることを求められ、ノドに小さくページ番号を入れる「隠しノンブル」という手法が推奨されることがあるようです。

Re:VIEW 3 以降では、ドキュメントクラスオプション `hiddenfolio=プリセット名` を使い、隠しノンブルを指定できます。

詳細については [Re:VIEW 3からのLaTeX処理](../latex/review3-latex.html) の「ページ番号に関する調整」を参照してください。

## コラム内に image や table を置くとエラーになります

コラムのような囲み内で「フロート」の図表を使うと、TeX のコンパイルエラーになります。Re:VIEW 3 では次のように「必ず指定箇所に置く（H）」を図表に指定することで、エラーを回避できます。

```
\floatplacement{figure}{H}
\floatplacement{table}{H}
```

- [図表のフロートを制御する](../latex/control-flow.html)

## 表内で @\<br\> を使ったときの見た目がよくありません

Re:VIEW 3.0 以降で解消しているはずです（[#1207](https://github.com/kmuto/review/pull/1207)）。

## 奥付を必ず偶数ページにするにはどうしたらよいですか？

Re:VIEW 3 では、`\reviewcolophon` マクロを変更します。デフォルトは単なる `\clearpage`（改ページ）なので、偶数になるように改ページする `\clearoddpage` に置き換えます。これには、sty/review-custom.sty に次のように追加します。

```
\renewcommand{\reviewcolophon}[0]{\clearoddpage}
```

この設定で POSTDEF が空の場合、CHAPS または APPENDIX の章の最後が白ページだと、白ページが連続します。これは `\backmatter` マクロ内で改ページが行われていることが原因なので、`\backmatter` の呼び出し元の `\reviewbackmatterhook` を空にするよう sty/review-custom.sty に次のように追加します。

```
\def\reviewbackmatterhook{}
```

## 章が奇数ページ始まりになっていますが偶数ページからも始まるようにしたいです

ドキュメントクラスオプションに `openany` を付けます。

```yaml
texdocumentclass: ["review-jsbook", "media=print,paper=a5,openany"]
```

## 各書体を変えるにはどうしたらよいですか？

- [使用書体の変更（upLaTeX 編）](../latex/uptex-fonts.html)

## PDF の作成に時間がかかります

よほど遅いプロセッサや少ないメモリでない限り、Re:VIEW 原稿から TeX 形式への変換、TeX コンパイルおよび PDF の生成には時間はあまりかからないはずです。サンプルドキュメントやプロジェクトの初期での PDF 作成時間に比して明らかに遅くなっているという場合、原因としては次のようなことが考えられます。

- eps ファイルの画像が使われている。eps ファイルは内部で Ghostscript により都度 PDF に変換されるので、時間がかかる要因になります。速度および管理の観点で PDF で統一しておくことを推奨します。
- 画像が多い。通常は数の問題ではないはずですが、config.yml のドキュメントクラスオプションに `draft` を付けて試してみるとよいかもしれません。このオプションを付けると、画像の領域は仮のボックスで代替されます。
- re ファイル上での相互参照が多い。現状の Re:VIEW の実装では、相互参照が指定されていたときにやや力まかせな方法で都度探索しています。re ファイルから TeX ファイルへの変換に時間がかかる可能性はありますが、TeX のコンパイル時間には関係ありません。
- review-ext.rb で時間のかかる処理を加えている。
- LuaLaTeX を使っている (これは速度面は理解の上で使われていると思いますが)。upLaTeX に比べると、だいぶ高速化してきたとはいえ LuaLaTeX は時間がかなりかかります。

## review-jsbook において、ページ番号を下部中央に配置するには、どうしたらよいですか？

review-jsbook では fancyhdr パッケージの機能を利用してヘッダおよびページ番号を設定しています。sty/review-style.sty で設定されているデフォルトでは、左側のページ（横書きにおいて偶数）の場合は左下、右側のページ（横書きにおいて奇数）の場合は右下に配置されます。

下部中央に変更するには、sty/review-custom.sty にたとえば以下のように記述します。

```
% ページ番号配置を下部中央にする
\fancyfoot{}% 既存の設定をキャンセル
\cfoot{\thepage}% 下部中央に配置

\fancypagestyle{plainhead}{% 章扉も変更
  \fancyfoot{}% 既存の設定をキャンセル
  \cfoot{\thepage}% 下部中央に配置
  \fancyhead{}% 以下はオリジナルのreview-styleと同じ
  \renewcommand{\headrulewidth}{0pt}%
  \renewcommand{\footrulewidth}{0pt}}
```

review-jlreq では fancyhdr ではなく jlreq クラス自体の機能を利用しているので、設定は異なります。review-style.sty の「ヘッダスタイル」の記述および jlreq クラスのドキュメントを参照してください。

## review-jsbook において、章名を左ページ、節名を右ページに配置するには、どうしたらよいですか？

review-jsbook では fancyhdr パッケージの機能を利用してヘッダおよびページ番号を設定しています。sty/review-style.sty で設定されているデフォルトでは、ヘッダ行に章名と節名の両方が配置されます。

希望の形に変更するには、sty/review-custom.sty にたとえば以下のように記述します。

```
% ヘッダをページによって切り替える
\fancyhead{}% 既存の設定をキャンセル
\fancyhead[LE]{\gtfamily\sffamily\bfseries\upshape \leftmark}% 左ページなら左側の見出し情報（一般に章名）
\fancyhead[RO]{\gtfamily\sffamily\bfseries\upshape \rightmark}% 右ページなら右側の見出し情報（一般に節名）
```

review-jlreq では fancyhdr ではなく jlreq クラス自体の機能を利用しているので、設定は異なります。review-style.sty の「ヘッダスタイル」の記述および jlreq クラスのドキュメントを参照してください。
