2022/10/29 by @kmuto

# Re:VIEW 5.6 での変更点

Re:VIEW 5.6 において 5.5 から変更した点について解説します。

----

2022年10月29日に、Re:VIEW 5 系のマイナーバージョンアップである「[Re:VIEW 5.6.0](https://github.com/kmuto/review/releases/tag/v5.6.0)」をリリースしました。

今回のバージョン 5.6 は、不具合の修正と、いくつかの機能向上、ドキュメントの更新を行いました。

----

## 既知の問題

現時点ではありません。

---

## インストール

新規インストールの場合

```
$ gem install review
```

更新の場合

```
$ gem update review
```

----

## 既存プロジェクトのバージョンアップ追従

既存のプロジェクトを 5.6 に更新するには、Re:VIEW 5.6 をインストール後、プロジェクトフォルダ内で `review-update` コマンドを実行してください。

```
$ review-update
** review-update はプロジェクトを 5.6.0 に更新します **
config.yml: 'review_version' を '5.0' に更新しますか? [y]/n 
プロジェクト/sty/review-base.sty は Re:VIEW バージョンのもの (/var/lib/gems/2.7.0/gems/review-5.6.0/templates/latex/review-jsbook/review-base.sty) で置き換えら
れます。本当に進めますか? [y]/n 
プロジェクト/sty/review-jsbook.cls は Re:VIEW バージョンのもの (/var/lib/gems/2.7.0/gems/review-5.6.0/templates/latex/review-jsbook/review-jsbook.cls) で置き換えられます。本当に進めますか? [y]/n 
完了しました。
```

　

続いて、リリースノートをベースに、新規に導入した機能や変更点について理由を挙げながら解説します。

## 新機能

### IDGXMLBuilder: `//texequation` と `@<m>` で `imgmath` math_formatに対応しました

ほかのビルダでは数式の画像変換に対応していたのですが、InDesign 用の IDGXMLBuilder だけまだ対応しませんでした。今回で対応しています。最近の InDesign では SVG にも対応していますので、PDF か SVG で書き出すのがよいでしょう。

### LATEXBuilder: `@<icon>`用のマクロとして`reviewicon`マクロを追加し、 `reviewincludegraphics`マクロの代わりに使うようにしました

これまで TeX 変換時にはインライン図版の `@<icon>` 命令を `\reviewincludegraphics` マクロに展開していたのですが、これだと使い分けや設定がしづらいという意見があり、`\reviewicon` マクロを導入してそれを使うようにしました。

### ルビ文字列の前後のスペースを削除するようにしました

ルビ命令 `@<ruby>` で区切り文字「,」の前後のスペースをビルダによって削除したりしなかったりと揺れていたので、スペースは自動削除することで統一しました。

## 非互換の変更

### LATEXBuilder: 囲み記事の見出しとして `■メモ` の代わりに `MEMO`, `NOTICE`, `CAUTION` 等を使うようにしました

review-jsbook  スタイルを使っているときに、`//note` や `//tip` などの囲み類の見出しがすべて「メモ」となってしまっていたのをやめて、「NOTE」「TIP」「INFORMATION」「WARNING」「IMPORTANT」「CAUTION」「NOTICE」「MEMO」と表現するようにしました。

この見出しは `locale.yml` で変更できます。例を示します。

```
locale: ja
note_head: 注記
tip_head: 小技
info_head: 情報
warning_head: 警告
important_head: 重要
caution_head: 危険
notice_head: 注意
memo_head: メモ
```

なお、TeX 以外のビルダではこの見出しは使われません。

## ドキュメント

### ドキュメント `format.md` と `format.ja.md` を更新しました

機能としては昔からあったのですがそういえばドキュメントのほうを更新していなかった、という命令について記載したり、少し整理を行いました。

- 上付き `@<sup>`、下付き `@<sub>` を説明
- 箇条書きネストについて少し追記、`//olnum` を説明
- 中央揃え `//centering` と 右揃え `//flushright` を説明
- `//raw` および `@<raw>` を非推奨化

本当は全体的に書き直したり、初期サンプルドキュメントも用意したいところではありますが。

## 終わりに

今回の Re:VIEW 5.6 もやや小幅な修正に留まりました。

前回同様にここ数ヶ月も公私で手一杯になっていて、あまり手がつけられませんでした。とはいえ、今回で少し便利になったり混乱を招きそうなところを手当てできたりはしたので良かったと思います。

Enjoy!
