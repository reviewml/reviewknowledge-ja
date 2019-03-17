2019/3/17 by @kmuto

# カスタムなページ（権利表記、広告や裏表紙など）の挿入

Re:VIEW がデフォルトで提供している、書籍に関するいくつかの生ファイルの取り込みスポットとその書き方を説明します。

----

EPUB や PDF での書籍を形成する際、Re:VIEW の範疇を超えた任意のレイアウトのページを入れる必要が生じることがあります。Re:VIEW は以下の箇所について（re ファイルではなく）HTML や TeX ソースなどの生のファイルを取り込む機能を提供しています。

- `titlefile`: 大扉（※これは Re:VIEW 側が一応デフォルトのものを提供します）
- `originaltitlefile`: 翻訳書での原書大扉
- `creditfile`: 権利表記
- `profile`: プロフィール
- `advfile`: 広告
- `colophon`: 奥付（※これは Re:VIEW 側が一応デフォルトのものを提供します）
- `backcover`: 裏表紙

これらは本文ほど決まったレイアウトがなく、汎用化しづらいものです。大扉と奥付は Re:VIEW がデフォルトのものを一応提供はするものの、もっと任意の形にしたいこともあるでしょう。
## EPUB での任意ファイルの挿入

EPUB 向けの任意ファイルは、単純な HTML と少し違い、EPUB 向けの XHTML 形式で記述する必要があります。特に注意することとして、HTML タグの省略は禁止されているので、img タグなどの単一タグは `<img 〜 />` のように閉じる必要があります。

EPUB向けの XHTML ファイルの雛型はたとえば以下のようになります。config.yml で `debug: true` を指定して EPUB を作成し、book-epub フォルダの中身から適当な HTML ファイルをコピーして使う、でもよいでしょう。

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops" xmlns:ops="http://www.idpf.org/2007/ops" xml:lang="ja">
<head>
  <meta charset="UTF-8" />
  <link rel="stylesheet" type="text/css" href="style.css" />
  <meta name="generator" content="Re:VIEW" />
  <title>プロフィール</title>
</head>
<body>
<div class="profile">
<h3>りびゅー太郎</h3>
<p><img src="images/reviewtaro.png" class="left" />
りびゅー太郎は、Re:VIEWの非公式ゆるキャラである。</p>
</div>
</body>
</html>
```

EPUB の場合は title タグの内容は無視されます。div タグで囲む必要も特にありませんが、CSS で固有の装飾をするときには囲んでおいたほうが指定しやすいでしょう。画像ファイルは別途 images フォルダに入れておきましょう。

上記の内容をプロジェクトフォルダ（config.yml と同じフォルダ）に `profile.xhtml` という名前で保存しておき、これをプロフィールページとして使うように config.yml に設定します。EPUB と PDF で別々のファイルを使いたいので、ここでは epubmaker セクションの下で設定することにします。

```
 …
epubmaker:
  profile: profile.xhtml
 …
```

これで、`rake epub` または `review-epubmaker config.yml` により生成される EPUB にプロフィールページが含まれるようになります。

ほかの取り込みパラメータも、パラメータ名が違うだけでやり方は同じです。

## PDF（LaTeX）での任意ファイルの挿入

PDFMaker でファイルを差し込むには、LaTeX で記述されたファイルを用意します。ただし、プリアンプルや `\begin{document}`・`\end{document}` は含みません。

ただ、LaTeX で「任意のレイアウト」を実現するには、それなりに LaTeX/TeX の知識を必要としますし、ベースのレイアウトのくびきから逃れるだけでも大変なので、何らかの方法で差し込み用の PDF を用意し、それを貼り込むのが最も簡単でしょう。

たとえば仕上がりと同じ紙サイズでのプロフィールの PDF「profile.pdf」を images フォルダに置き、以下の内容をプロジェクトフォルダに `profile.tex` という名前で保存します。

```
\includefullpagegraphics{images/profile.pdf}
```

これをプロフィールページとして使うように config.yml の pdfmaker セクションに設定します。

```
 …
pdfmaker:
  profile: profile.tex
 …
```

これで、`rake pdf` または `review-pdfmaker config.yml` により生成される PDF にプロフィールページが含まれるようになります。
