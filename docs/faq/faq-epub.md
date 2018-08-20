# FAQ - Re:VIEW の使い方について（EPUB・WebMaker）

FAQ（よくある質問と回答）のこのセクションは、Re:VIEW の使用方法のうち、EPUB および Web ページの生成に関係する事柄をまとめています。

----

## EPUB に変換するにはどうしたらよいですか？

```
rake epub
```

または

```
review-epubmaker config.yml
```

## EPUB から PDF を作ることはできませんか？

- EPUB をそのまま PDF 変換する：[VersaType Converter](https://trim-marks.com/ja/)、[EPUB to PDF変換ツール](https://www.antenna.co.jp/epub/epubtopdf.html) など）
- EPUB の HTML を結合し（これを簡単に実行できる `review-epub2html` というコマンドがあります）、Web ブラウザ上で整形したものを PDF として保存する（[Vivliostyle.js](https://vivliostyle.org/) など）
