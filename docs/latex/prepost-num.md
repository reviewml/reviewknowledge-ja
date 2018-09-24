2018/9/24 by @kmuto

# 前付（PREDEF）、後付（POSTDEF）の図表採番を本章同様にリセットする

jsbook を使ったテンプレートを利用していて、図表を前付や後付で多用する場合、番号のリセットがうまく効きません。これを修正する方法を示します。

----

## 採番で発生する奇妙な挙動

Re:VIEW の前付（PREDEF）や 後付（POSTDEF）に re ファイルを割り当て、かつそれぞれで採番付きの図表（image や table）を使った場合、一般的な jsbook 基盤のテンプレートを使っていると次のような挙動になります。

- 図1、図2、……のような採番になる
- しかし、通常の章では章が変わるごとに番号のカウントが1に戻るのに対し、前付は re ファイルが変わってもカウントは戻らず、前のファイルでの採番の続きとなる
- さらに悪いことに後付は CHAPS で割り当てられた最後の章の採番を引き継ぐ

これは通常は意図に反する挙動でしょう。

##  jsbook と chapter の挙動

LaTeX の内面で見ていくと、次のようになっています。

- 前付は `\frontmatter`、本文は `\mainmatter`、後付は `\backmatter` という3つのマクロ宣言で切り分けられている（章として扱うかどうか、ページ番号をどう表現するかなどがここで設定される）
- 図 `figure` や 表 `table` のカウンタは、`chapter` に依存してカウントされる
- 各見出しは `\chapter` マクロで表され、この中で「mainmatter 内なら `\refstepcounter{chapter}`」によってカウンタをリセットする。**それ以外の場合はリセットしない**

2018年9月時点の jsbook.cls (2018/06/23 バージョン) でも対処されておらず、またこれを変更すると既存の文書に影響が大きいことから、「仕様」と判断されます。

なお、Re:VIEW の図表参照（`@<img>`、`@<table>`）のほうは、TeX から導く `\ref` マクロではなく、Re:VIEW の時点で決定した番号をそのままの文字列（リテラル）で書き出しているので、参照側は前付・後付でも「正しい」番号になります。

## 対処方法A

おそらく現時点では最も妥当な方法と思われます。ただし、jsbook.cls 側の変更があったときには不整合が生じる可能性があります。

`\chapter` マクロで mainmatter 以外でも `\refstepcounter{chapter}` でリセットするようにします。ただ、これだけでは前付・後付に「章番号」が付いてしまうので、ダミーの番号を入れて隠す、という手順を入れます。

`sty/review-custom.sty`（Re:VIEW 3 系）または `reviewmacro.sty`（Re:VIEW 2 以前）に次のように追加します。

```
\renewcommand\frontmatter{% frontmatter再定義
  \if@openright
    \cleardoublepage
  \else
    \clearpage
  \fi
  \@mainmatterfalse
  \pagenumbering{roman}%
  \setcounter{chapter}{-100}% 前付用のダミー章番号を追加する
}

\renewcommand\mainmatter{%
    \cleardoublepage
  \@mainmattertrue
  \pagenumbering{arabic}%
  \setcounter{chapter}{0}% mainmatterで章番号をいったんリセットする
}

\renewcommand\backmatter{%
  \if@openright
    \cleardoublepage
  \else
    \clearpage
  \fi
  \@mainmatterfalse%
  \setcounter{chapter}{-100}% 後付用のダミー章番号を追加する
}

\def\@chapter[#1]#2{%
  \ifnum \c@secnumdepth >\m@ne
    \if@mainmatter
      \refstepcounter{chapter}%
      \typeout{\@chapapp\thechapter\@chappos}%
      \addcontentsline{toc}{chapter}%
        {\protect\numberline
        % {\if@english\thechapter\else\@chapapp\thechapter\@chappos\fi}%
        {\@chapapp\thechapter\@chappos}%
        #1}%
    \else%
      \refstepcounter{chapter}\phantomsection% mainmatter以外でもカウンタリセット
      \addcontentsline{toc}{chapter}{#1}\fi
  \else
    \addcontentsline{toc}{chapter}{#1}%
  \fi
  \chaptermark{#1}%
  \addtocontents{lof}{\protect\addvspace{10\jsc@mpt}}%
  \addtocontents{lot}{\protect\addvspace{10\jsc@mpt}}%
  \if@twocolumn
    \@topnewpage[\@makechapterhead{#2}]%
  \else
    \@makechapterhead{#2}%
    \@afterheading
  \fi}
```

## 対処方法B

本質的な解決ではありませんが、対処方法Aよりも場当たりに対処する方法もあります。

図表がある前付や後付の re ファイルに、カウンタの強制リセットを挿入します。見出しの直後にでも入れておくとよいでしょう。

```
= （見出し）
//embed[latex]{
\setcounter{figure}{0}
\setcounter{table}{0}
//}
```

## 対処方法C

jsbook.cls 以外の新規に作成されたドキュメントクラスファイル（jlreq など）では、この問題が発生しないと思われます。
