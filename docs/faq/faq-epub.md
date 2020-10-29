# FAQ - Re:VIEW の使い方について（EPUB・WebMaker）

FAQ（よくある質問と回答）のこのセクションは、Re:VIEW の使用方法のうち、EPUB および Web ページの生成に関係する事柄をまとめています。

----

## EPUB とは何ですか？

電子書籍フォーマットの世界標準です。多くのリーダーソフトがあり、PC やスマートフォンで本を開くことができます。

中身としては、HTML と CSS を使っていますが、通常は JavaScript は禁止され、CSS の一部も使えないような制約された表現に抑制されています。

ページ表現としては、リフロー型とフィクス型の2種類があります。

- **リフロー型**：Web ブラウザと同様に表示サイズや基本フォントサイズによって1ページあたりに表現する範囲が変化します。
- **フィクス型**：ページを1つの画像として、紙の本と同じ表現で固定します。

Re:VIEW が生成する EPUB はリフロー型です。

## EPUB に変換するにはどうしたらよいですか？

```
rake epub
```

または

```
review-epubmaker config.yml
```

## Web ページに変換するにはどうしたらよいですか？

```
rake web
```

または

```
review-webmaker config.yml
```

これで、プロジェクトの webroot フォルダに公開用の HTML ファイルが作成されます。

## 生成される EPUB のバージョンはいくつですか？

デフォルトでは EPUB バージョン 3 のファイルが生成されます。config.yml の `epubversion`（デフォルトは3）および `htmlversion`（デフォルトは5）のパラメータで調整できますが、古いバージョンについては今後サポートを終了する可能性があります。

## 生成された EPUB が標準に合致しているかどうかの確認はどうしたらよいですか？

- [EpubCheck](https://github.com/w3c/epubcheck/releases)

## Kindle 用の mobi ファイルは作れますか？

Re:VIEW 自体にその機能はありませんが、Amazon が無料で配布している Kindle Previewer（[https://www.amazon.com/gp/feature.html?ie=UTF8&docId=1000765261](https://www.amazon.com/gp/feature.html?ie=UTF8&docId=1000765261)）というソフトウェアで EPUB から変換できます。

なお、論理目次だけではエラーが報告されるようです。物理目次ページを付けるためには、次のように config.yml に設定します。

```yaml
epubmaker:
  toc: true
```

かつては Linux にも対応した CUI の KindleGen というコマンドがありましたが、すでに配布が停止し、Windows または macOS で動作する GUI ベースの Kindle Previewer のみが Amazon 公式の変換ツールです。

## 「電書協ガイドライン」に従った EPUB は作れますか？

[電書協ガイドライン](http://ebpaj.jp/counsel/guide) は、紙の本を電子書籍化する過程で EPUB の仕様を知らない制作会社でも迷わないように策定されたローカル規約です。EPUB の標準よりもファイル名やフォルダ構成、タグの付け方などに縛りがあります。

完全に準拠しているかという観点で言えば、Re:VIEW の EPUB は準拠していません。メタファイルに電書協ガイドラインの必須属性を追加するだけならば、config.yml に以下のように加えます。

```yaml
opf_prefix: {ebpaj: "http://www.ebpaj.jp/"}
opf_meta: {"ebpaj:guide-version": "1.1.3"}
```

##  iBooks で EPUB を開いたときに左右ページの間に影ができます

config.yml に以下のように加えると、影を消せます。

```yaml
opf_prefix: {ibooks: "http://vocabulary.itunes.apple.com/rdf/ibooks/vocabulary-extensions-1.0/"}
opf_meta: {"ibooks:binding": "false"}
```

上記の電書協ガイドラインの設定もある場合は以下のようにします。

```yaml
opf_prefix: {ebpaj: "http://www.ebpaj.jp/", ibooks: "http://vocabulary.itunes.apple.com/rdf/ibooks/vocabulary-extensions-1.0/"}
opf_meta: {"ebpaj:guide-version": "1.1.3", "ibooks:binding": "false"}
```

## EPUB から PDF を作ることはできませんか？

- EPUB をそのまま PDF 変換する：[VersaType Converter](https://trim-marks.com/ja/)、[EPUB to PDF変換ツール](https://www.antenna.co.jp/epub/epubtopdf.html) など）
- EPUB の HTML を結合し（これを簡単に実行できる `review-epub2html` というコマンドがあります）、Web ブラウザ上で整形したものを PDF として保存する（[Vivliostyle.js](https://vivliostyle.org/) など）
- [Re:VIEW+CSS組版 執筆環境構築](https://github.com/at-grandpa/review-and-css-typesetting) の仕組みを流用する（おおむね上記のことを内部でしている）

## CSS を変更するにはどうしたらよいですか？

デフォルトでプロジェクトに展開される style.css ファイルを編集できます。

config.yml の `stylesheet` パラメータで別ファイルを指定したり、複数指定したりすることも可能です。

## Web フォントは利用できますか？

WebMaker で生成した Web ページでは、CSS で設定していれば利用可能です。

EPUB については、EPUB リーダーが対応していれば可能ですが、そのようなリーダーが存在するかは不明です。

## 縦書き右綴じにするにはどうしたらよいですか？

縦書きにするには、CSS で文字方向を縦にする必要があります。

```
body {
  ...
  -webkit-writing-mode: vertical-rl;
  -epub-writing-mode:   vertical-rl;
  writing-mode: tb-rl;
}
```

さらに、config.yml で EPUB のページ送りを右から左に遷移するよう指定します。

```yaml
direction: "rtl"
```

実際に縦書きが正常に表示されるかは、EPUB リーダーの能力に依存します。

## 数式を入れたいのですが良い方法はありませんか？

[Re:VIEW フォーマットガイド](https://github.com/kmuto/review/blob/master/doc/format.ja.md#) の「TeX 式」を参照してください。imgmath という機能で TeX 式を画像化できます。

## コードハイライトを使うにはどうしたらよいですか？

highlight 設定を有効にします。現時点で有効な値は `rouge` または `pygments` です。前者の場合は rouge gem パッケージ、後者の場合は pygments.rb gem パッケージおよび Python の pygments コマンドが必要です。

```
highlight:
  html: "rouge"
```

ハイライト解析に使う言語をリストの言語設定（emlist 系では第2、list 系では第3オプション）で指定する必要があります。

```
//emlist[][ruby]{
def hello
  puts 'Hello.'
end
//}
```

## ハイライトを有効にすると、コード内のインライン命令がそのまま出てしまいます

ハイライトとインライン命令は極めて相性が悪く、現状ではまだ妥当な解決方法がありません。ハイライトを使う箇所ではコード内のインライン命令は使わないようにしてください。

どうしてもという場合、いったんインライン命令を隠し、ハイライトをかけてからインライン命令を戻す、という処理が必要です。([#1256](https://github.com/kmuto/review/pull/1256))

## 複数のスペース文字を入れても、1つになってしまいます。どうしたらよいですか？

どうしてもリテラルなスペースを入れたいときには、以下のようにして埋め込みます。

```
3つのスペースを@<embed>{|latex|~~~}@<embed>{|html|&nbsp;&nbsp;&nbsp;}と入れる
```

## 見出しのない re ファイルが EPUB に収録されません

EPUBMaker は論理的な目次を作って管理しているため、見出しのない re ファイルから生成されるコンテンツは欠落してしまいます。

見出しの nodisp オプションを使うと、「目次に含めるけれどもコンテンツ側には表示しない」見出しを定義できます。たとえば以下の例では、「謝辞」という見出しは目次のみに登場し、コンテンツでは「ありがとうございます。」のみが表示されます。

```
=[nodisp] 謝辞

ありがとうございます。
```

どうしても目次にも表示したくない場合は、フックで目次の HTML ファイルを書き換えてください。

## 複雑な表表現をしたいです

Re:VIEW の表表現はシンプルな縦横表の記述を前提にしています。セル結合や任意の罫線、箇条書きを含めるなどの複雑な表を表現するには不向きなので、画像として作成し、`//imgtable` 命令を使って貼り込むことを検討してください。
