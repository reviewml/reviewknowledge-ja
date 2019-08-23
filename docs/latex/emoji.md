2019/8/24 by @kmuto

# Re:VIEW + upLaTeX で絵文字を使う

Re:VIEW + upLaTeX の環境で絵文字を使うための手順を紹介します。

----

Unicode に絵文字が取り込まれたことで、ネット文化では🍣だの🤔だのやりたい放題の感がありますが、Re:VIEW + upLaTeX でそのままこれを利用しようとすると「PDF から全部消えてる…😱」という厳しい結果が待っています。

@zr-tex8r さん作の [BXcolormoji](https://github.com/zr-tex8r/BXcoloremoji/) というパッケージを使うと、画像化された絵文字を埋め込むことができます。

## BXcoloremoji のインストール
[BXcoloremoji/Release](https://github.com/zr-tex8r/BXcoloremoji/releases) から、最新版の zip または tar.gz ファイルをダウンロードし、README.md のインストール手順に従ってインストールします。

Linux/macOS の場合、ごく単純には `~/texmf/tex/latex` のフォルダを作り、ここにアーカイブファイルを展開しておけばよいでしょう。

## BXcoloremoji パッケージの利用宣言
インストールした BXcoloremoji を利用するため、プロジェクトの `sty/review-custom.sty` にパッケージの利用宣言を追加します。

```
\usepackage{bxcoloremoji}
```

いくつかのオプションを付けることも可能ですが（ドキュメントを参照）、通常はこれだけで十分です。

## 絵文字を使うための設定
re ファイルに適当に絵文字を入れるだけでは BXcoloremoji のマクロの対象になりません。tex ファイル化する際の最終結果を書き換えるか、あるいは絵文字用の Re:VIEW のインライン命令を追加するかのどちらかが必要です。ここでは絵文字を使うということを強く意識するために後者のインライン命令を追加する方法をとることにします。プロジェクトに置く `review-ext.rb` は以下のとおりです。

```
module ReVIEW
  module BuilderOverride
    Compiler.definline :emoji

    def inline_emoji(s)
      s
    end
  end

  class Builder
    prepend BuilderOverride
  end

  module LATEXBuilderOverride
    def inline_emoji(s)
      "\\coloremoji{#{s}}"
    end
  end

  class LATEXBuilder
    prepend LATEXBuilderOverride
  end
end
```

`@<emoji>{絵文字}` というインライン命令を追加しました。ほかのビルダではそのまま絵文字を通すようにし、LaTeX ビルダでは BXcoloremoji で提供される `\coloremoji` マクロに絵文字を渡します。

- EPUB の場合、PC やタブレットであれば問題ありませんが、Kindle 端末のような専用デバイスでは絵文字はまともに表示されない可能性が高いことに注意してください（結局 BXcoloremoji がやっているような画像化の措置が必要かもしれません）。
- InDesign の場合、絵文字の利用はまだリスクが高いです。絵文字などをそのまま利用できる OpenType-SVG をサポートする InDesign や Illustrator はある程度新しいバージョンに限られるので、商業出版刊行しようという原稿の場合は、利用する前に本当に使ってよいか制作関係者に確認すべきです。
- 絵文字を指定する際に、直接その文字を `@<emoji>` 命令内に書き込むのではなく、`\coloremojiucs` マクロを使って符号値列や短縮名で指定する、という方法もあります（ほかのビルダ向けにはなんとかして元の絵文字を構築する必要がありますが）。

絵文字を埋め込んだ例を以下に示します。

![絵文字の利用例](images/emoji.png)

絵文字の使いすぎには注意しましょう 😱😱😱

- [LaTeX でもっともっとカラー絵文字する話](https://zrbabbler.hatenablog.com/entry/20160504/1462330427)
- [BXcoloremoji](https://github.com/zr-tex8r/BXcoloremoji)
