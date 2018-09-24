# FAQ - Re:VIEW の使い方について（TeX PDF）

FAQ（よくある質問と回答）のこのセクションは、Re:VIEW の使用方法のうち、TeX を使った PDF 生成に関係する事柄をまとめています。

----

## TeX 環境の構築はどうしたらよいですか？

## LaTeX を使った PDF に変換するにはどうしたらよいですか？

## LaTeX の紙面レイアウトに満足がいきません。どうやったら置き換えられますか？

## LaTeX の紙面レイアウトとして他のテンプレートはありますか？

デフォルトのもの以外に広く使われているものとして、TechBooster 提供のテンプレートがあります。

- [https://github.com/TechBooster/ReVIEW-Template](https://github.com/TechBooster/ReVIEW-Template)

## LuaTeX-ja を使うにはどうしたらよいですか？

Re:VIEW 3 以上で LuaTeX への対応を進めています。ただし、現状では LuaTeX を使うユーザーが LaTeX についての十分な知識を持っており、問題を自己解決できるだけの能力があることを前提としています。

1. config.yml の `texdocumentclass` パラメータを LuaTeX-ja のものに変更する（`texdocumentclass: ["ltjsbook", "oneside"]` など）。
2. `texcommand` パラメータを変更する。`texcommand: "lualatex"`
3. `dvicommand` パラメータを null にする（`dvicommand: null`）。これは特に重要です。単にコメントアウトするだけでは、デフォルトの upLaTeX 用の `dvicommand` パラメータ値が有効になってしまいます。
4. プロジェクトの sty フォルダのファイル群で LuaTeX-ja に対応していないところを調整する。

## トンボを付けるにはどうしたらよいですか？

- [jsbook ベースのドキュメントにトンボおよびデジタルトンボを配置する](../latex/tex-tombow.html)

## 入稿先に PDF/X-1a 形式か PDF/X-4 形式にするよう求められました。どうしたらよいですか？

PDF/X-1a、PDF/X-4 は印刷用 PDF として準拠の求められることの多い標準規格ですが、現時点でフリーソフトウェアの範囲ではこれに明確には対応できません。たとえば以下のような有償ソフトウェアを利用して変換することを推奨します。

- Adobe 社 Acrobat：[https://acrobat.adobe.com/jp/ja/acrobat.html](https://acrobat.adobe.com/jp/ja/acrobat.html)
- callas 社 pdfToolbox：[https://www.callassoftware.com/en/products/pdftoolbox](https://www.callassoftware.com/en/products/pdftoolbox)

## 全体をグレースケールにするにはどうしたらよいですか？

## コンパイルや PDF 生成処理の途中に割り込むにはどうしたらよいですか？

- [フックで LaTeX 処理に割り込む](../latex/tex-hook.html)

## 長い表がはみ出してしまうのですが、ページで分割するにはどうしたらよいですか？

## 等幅の長い文字を入れると文字の間がスカスカになってしまいます。途中で折り返させるにはどうしたらよいですか？

- [見栄えが悪い箇所を「少しだけ」調整する](../latex/modify-abit.html)

## ページの途中で強制的に改ページするにはどうしたらよいですか？

- [見栄えが悪い箇所を「少しだけ」調整する](../latex/modify-abit.html)

## あるページの版面を少しだけ伸ばすにはどうしたらよいですか？

- [見栄えが悪い箇所を「少しだけ」調整する](../latex/modify-abit.html)

## PREDEF、POSTDEF で割り当てたファイルで図表を使うと、おかしな番号の振り方になります。

- [前付（PREDEF）、後付（POSTDEF）の図表採番を本章同様にリセットする](../latex/prepost-num.html)

## jsbook ベースのテンプレートで、ページを頭からの通し番号にするにはどうしたらよいですか？

jsbook.cls では以下の2箇所で暗黙にページ番号を変えているため、マクロを上書きする必要があります。

- titlepage（大扉などで利用）でページ番号を0にリセット
- 前付（frontmatter）でローマ数字、本文（mainmatter）でアラビア数字化。それぞれ `pagenumbering` マクロを使用しており、このマクロで番号は0にリセットされる

単純に頭からの通し番号にするには、`sty/review-custom.sty`（Re:VIEW 3 系）または `reviewmacro.sty`（Re:VIEW 2 以前）に次のように書いて jsbook.cls のマクロを上書きします。

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
