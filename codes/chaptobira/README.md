# 章扉に画像を貼り付ける例

2021/9/29 @kmuto

凝った章扉を付けたいときに、TeX や Re:VIEW でがんばるのは大変、または現実的でない。かといって、生成した PDF を後で手で加工するというのも、繰り返しに不向きである。

Illustrator などのツールを使って実寸 (+ 印刷用の塗り足し) の PDF、または Illustrator ネイティブファイルを用意し、それを章扉として利用する例を示す。

- TeXLive のある環境において、rake pdf で book.pdf が作成される。
- 章見出し表現を任意に変更しやすいため、jsbook ではなく jlreq を使っている (review-init --latex-template=review-jlreq で作成したプロジェクト)。
- images/chapter章番号.ai を用意する (PDF でもよい)。
- sty/review-custom.sty で chapter を TobiraHeading に変更し、chapter 値に対応するファイルを貼り付ける。PDF の場合はこの review-custom.sty で定義している format オプションの .ai を .pdf にすること。

現時点の jlreq.cls では目次見出しに \chapter を使っているため、元々の \chapter 表現をバックアップして、目次内ではそれを使うようにしている。

## アイデア
- format には番号や見出し文字列も引数で渡されているので、扉画像側に埋め込まずにがんばることも可能ではある。(`\textpos` を使って絶対位置指定するなど。TikZ を利用する方法もありそう)
- たとえば見出し以外にエピグラフを入れたいというときに、jlreq.cls の見出しは副題をサポート (`\chapter{見出し}[副題]`) していて format にも渡されるので、これを活用するのがよいかもしれない。
  - Re:VIEW からこれにどう展開するかだが、review-ext.rb で headline メソッドを書き換えることになるだろう。副題に入れるエピグラフ文字列群については、review-ext.rb でついでに定義してしまうか、テキストファイルで用意しておいて読み込むことが考えられる。
