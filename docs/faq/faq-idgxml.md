# FAQ - Re:VIEW の使い方について（InDesign）

FAQ（よくある質問と回答）のこのセクションは、Re:VIEW の使用方法のうち、InDesign での制作に関係する事柄をまとめています。

----

## InDesign とは何ですか？

Adobe 社が開発している、プロユースの DTP ソフトウェアです。月々または年間のサブスクリプション契約制です。

手作業を念頭に置いているので自由度の高い紙面が作れます。TeX PDF のような完全自動の紙面作成はできませんが、XML のインポート機能と JavaScript による「半自動」の紙面作成は可能です。

- [https://www.adobe.com/jp/products/indesign.html](https://www.adobe.com/jp/products/indesign.html)

## InDesign ファイルに変換する maker コマンドがないようです。どうやって変換するのですか？

Re:VIEW 4 以降では、`review-idgxmlmaker` コマンドが導入されました。

```
rake idgxml
review-idgxmlmaker config.yml
review-idgxmlmaker -f フィルタプログラム config.yml
REVIEW_CONFIG_FILE=config-idgxml.yml REVIEW_IDGXML_OPTIONS="-f フィルタプログラム" rake idgxml
```

フィルタプログラムは、標準入力で XML を受け取り、標準出力に加工した XML を書き出すという挙動が期待されます。フィルタプログラムで処理対象の re ファイル名を知るには、`REVIEW_FNAME` 環境変数を参照してください。

Re:VIEW 3 以下では、Re:VIEW のコンパイルコマンドを直に使用する必要があります。IDGXML ビルダを使うよう、`--target=idgxml` を指定します。

```
review-compile --yaml=config.yml --target=idgxml reファイル名 > xmlファイル名
```

表がある場合、版面の幅を `--table=` オプションに数値で指定します（mm 単位）。

```
review-compile --yaml=config.yml --table=版面幅 --target=idgxml reファイル名 > xmlファイル名
```

## IDGXML ビルダが生成される XML ファイルはいったい何ですか？

re ファイルの内容をシンプルな XML 形式で表現したものです。ただし、表の表現などの一部は InDesign 固有の XML 表現形式になっています。

この XML ファイルはあくまでも中間形式であり、紙面レイアウトに合わせて適切に加工することを想定しています。

## 中間形式の紙面に合わせてどのような作業をしたらよいのですか？

大きく次の3つの作業が必要です。

- 紙面デザインの InDesign ファイルを、「できるだけ流し込みで、インラインフレームを使わずに済む」よう調整する。
- IDGXML ビルダの生成した XML ファイルを、紙面デザインに合うようにスタイル名を設定したり加工したりする。
- 手作業では頻繁・煩雑な調整を、JavaScript のプログラムで代替する。

## なぜ IDGXML の XML ファイルには改行が入っていないのですか？

要素中に改行を入れる・入れないは紙面レイアウトによって変化するため、迂闊に人間が見やすいようにと改行を入れてしまうと、「後工程で不要な改行を消す」という手間が増えます。これは「後工程で改行を入れる」に比べて必要だった改行まで消してしまう恐れがあります。

そのため、Re:VIEW の XML ファイルはコードリスト途中の改行や `@<br>` 命令で入れた強制改行以外には改行を入れていません。

## なぜ IDGXML の XML ファイルは浅い構造なのですか？

XML ドキュメントは、各行ごとに InDesign の段落に割り当てられます。改行文字がそのまま段落表現になるため、改行の入れ方には注意が必要ですが、XML ドキュメントによく見られるような深い階層構造にしてしまうと、その行に改行が入るかどうかを追跡するのはとても困難な作業になります。

また、InDesign 自体の XML の処理能力は貧弱で、階層を追跡するような実行操作は非常に遅く、頻繁にクラッシュします。

Re:VIEW 自体もその言語の性質上、複雑な XML 階層構造に向いているわけでもありません。

## よくわかりません……Re:VIEW と InDesign の組み合わせについての参考書はありますか？

現時点で以下の書籍があります。

- [『Re:VIEW+InDesign制作技法』](https://tatsu-zine.com/books/review-indesign) （PDF または EPUB）

## InDesign での実績はあるのでしょうか？

開発チームの武藤健志（@kmuto）が業務で請負制作した書籍のほとんどは、InDesign を使用しています。

- [利用実績](https://github.com/kmuto/review/wiki/利用実績)

## InDesign の IDML 形式に変換することはできますか？

いいえ。

InDesign のバージョン間のデータ互換性保持によく使われる IDML は XML 形式のアーカイブファイルですが、紙面レイアウトと強く結び付いているため、仮にそのようなデータを生成したとしても紙面レイアウトを柔軟に変えることができません。

もし固有のレイアウトが決まっていて一切のスタイルの変更などもないのであれば、専用の IDML ビルダ・メーカーを作ること自体は可能でしょうが、公式に対応することはありません。

## InDesign の ICML 形式に変換することはできますか？

いいえ。

InDesign のサブツール InCopy で使われるコンテンツファイル形式の ICML も、XML 形式のファイルではあります。現状では開発チームにとって必要性が感じられないのでサポートしていませんが、スタイル名の決め打ちを前提とすれば実装は比較的容易だとは思われます。

- 参考 [Markdownを起点とするワークフロー](http://www.dtp-transit.jp/adobe/indesign/post_2157.html)

## ほかの変換器で IDGXML 形式を作ることはできますか？

IDGXML 形式自体、仕様としては実装しかないので、互換性というほどの規則はありません。ただ、Re:VIEW と類似のドキュメント処理システム Sphinx から IDGXML に変換するビルダは存在し、InDesign での制作実績があります。

IDGXML になってしまえば、あとは既存の IDGXML 向けのフィルタおよび InDesign 上の JavaScript を利用できます。

- [Sphinx Indesign Builder](https://github.com/shirou/sphinxcontrib-indesignbuilder)
