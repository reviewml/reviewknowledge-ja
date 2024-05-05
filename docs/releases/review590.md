2024/5/5 by @kmuto

# Re:VIEW 5.9 での変更点

Re:VIEW 5.9 において 5.8 から変更した点について解説します。

----

2024年5月4日に、Re:VIEW 5 系のマイナーバージョンアップ「[Re:VIEW 5.9.0](https://github.com/kmuto/review/releases/tag/v5.9.0)」をリリースしました。

時間取れないですね……定期リリースをし損ねました。修正のみのリリースとなります。

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

既存のプロジェクトを 5.9 に更新するには、Re:VIEW 5.9 をインストール後、プロジェクトフォルダ内で `review-update` コマンドを実行してください。

```
$ review-update
** review-update はプロジェクトを 5.9.0 に更新します **
config.yml: 'review_version' を '5.0' に更新しますか? [y]/n 
プロジェクト/sty/review-base.sty は Re:VIEW バージョンのもの (/var/lib/gems/2.7.0/gems/review-5.9.0/templates/latex/review-jsbook/review-base.sty) で置き換えら
れます。本当に進めますか? [y]/n 
プロジェクト/sty/review-jsbook.cls は Re:VIEW バージョンのもの (/var/lib/gems/2.7.0/gems/review-5.9.0/templates/latex/review-jsbook/review-jsbook.cls) で置き換えられます。本当に進めますか? [y]/n 
完了しました。
```

　

続いて、リリースノートをベースに、変更点について理由を挙げながら解説します。

## バグ修正
### LATEXBuilder: `@<code>`, `@<tt>`, `@<tti>`, `@<ttb>`での空白幅が適切になるよう修正しました。またPDF栞の扱いを改善しました

codeなどのコード書体にするインライン命令内で`:`や`.`の後にスペースを入れると、英語表現として空白が大きくなるのがこれまでのLaTeX由来の挙動でしたが、Re:VIEWのユーザーは書体だけでなく等幅であることを期待すると思われるため、空白幅が変わらないようにしました。

review-base.styファイル上での修正となるため、これを更新しなければ既存の制作物への影響はありません。

また、これに関連して、一部の命令が節名などに含まれていたときにPDFしおりがうまく動かない可能性のあるケースに対処しました。

munepiさんありがとうございます！

## 機能強化
### review-jlreq.clsのUsers Guideで用紙サイズの指定のJIS B列とISO B列を区別するようにしました

jlreq.clsの最近（といってもしばらく前から）のバージョンでは用紙サイズにB列（たとえばb5）と指定するとJIS B列ではなくISO B列のサイズを採用してしまい、通常の期待サイズと異なることになります。

READMEにJISとISOの注意を記載し、サンプルの例示でも「b5j」を使うようにしました。

### `config.yml.sample`での誤記を修正しました

lが入っているというSKK仕草です……。

koshikawaさんありがとうございます！

## 終わりに

今月は技術書典16ですね！ どうするとRe:VIEWを使って執筆する方々を支援できるかな〜
