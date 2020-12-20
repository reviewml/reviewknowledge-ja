2018/7/30, 2020/12/20 by @kmuto

# Re:VIEW のモンキーパッチによる拡張の基本

`review-ext.rb` をプロジェクトに置くことで、Re:VIEW のロジックを上書きできます。新しい命令を追加したり、既存の命令の挙動を変更したりするのに使えます。

----

## review-ext.rb

プロジェクトに `review-ext.rb` という名前のファイルを置くと、review-pdfmaker などの Re:VIEW の各コマンドの実行時にこのファイルが取り込まれ、Re:VIEW 自身が書き換えられます（モンキーパッチと呼びます）。

使いすぎに注意する必要はありますが、独自の新しい命令を追加したり、既存の命令で不都合に思われる挙動を変更したりできます。

`review-ext.rb` は Re:VIEW の Ruby ロジックを書き換える都合上、当然ながら Ruby のプログラムファイルです。基本構造は次のとおりです。

```
module ReVIEW
  module BuilderOverride
    # 「Builder」のメソッドへの上書き・追加など
  end

  class Builder
    prepend BuilderOverride  # これでBuilderに上書きが反映される
  end
end
```

最初の `module ReVIEW` と最後の `end` で全体を囲みます。

この中には `module BuilderOverride` 〜 `end` と、`class Builder` 〜 `end` の 2 つのブロックがあります。

前者が上書き用の定義で、後者が既存のビルダクラスに適用するための定型の記述です。`BuilderOverride` という名前はわかりやすさのためにこうしていますが、実際に使用するときにはほかの既存の名前と競合しなければ任意の名前でかまいません。

ビルダとは、原稿ファイル（.re）から変換するルールおよび手続きを定義したクラスです。Re:VIEW がサポートする変換形式に合わせて、代表としては以下のものがあります。

- `Builder`（builder.rb）：以下の各ビルダの基底クラス。主に全ビルダに新規の命令を追加したいときにこれを拡張することになるでしょう。
- `IndexBuilder` (indexbuilder.rb) ：Re:VIEW 5.0 から導入されたクラスで、実際の各ビルダに通す前に図表などの番号の管理を行うクラス。
- `HTMLBuilder`（htmlbuilder.rb）：epubmaker や webmaker で使っている HTML 変換のビルダクラス。
- `LATEXBuilder`（latexbuilder.rb）：pdfmaker で使っている LaTeX 変換のビルダクラス。
- `IDGXMLBuilder`（idgxmlbuilder.rb）：InDesign XML 変換のビルダクラス。
- `TOPBuilder`（topbuilder.rb）：textmaker で使っている装飾付きプレインテキスト変換のビルダクラス。
- `PLAINTEXTBuilder`（plaintextbuilder.rb）：textmaker で使っている装飾なしプレインテキスト変換のビルダクラス。

各ビルダのクラス定義ファイルは、Re:VIEW ソースの `lib/review/` にあります。

ここでは全ビルダの基底クラスである `Builder` を `BuilderOverride` の定義内容で上書きする、ということになります（Ruby の `prepend` 命令が実際の上書きの調整をします）。

## 警告！ 警告！

Re:VIEW の内部ロジックはメジャーバージョンはもとより、マイナーバージョンでも頻繁に変更されています。

review-ext.rb で Re:VIEW のロジックを書き換える場合、書き換えた Re:VIEW バージョンに束縛されることに注意してください。別の Re:VIEW バージョンに移行したときには、review-ext.rb にも修正が必要となる可能性が高いと考えてください。

## 既存の命令の書き換え（インライン命令）

インライン命令の書き換えは容易です。同名のメソッドおよび同じ数の引数で定義し直すだけです。インライン命令のメソッドは文字列を返すようにします。ビルダにおいて、インライン命令のメソッド名は `inline_` から始まります。

HTML/EPUB での脚注参照記号は「`*番号`」ですが、これを変更してみます。`HTMLBuilder` では以下のようになっています。

★本当はこれはi18n.ymlの仕事にすべき？

```
   def inline_fn(id)
      if @book.config['epubversion'].to_i == 3
        %Q(<a id="fnb-#{normalize_id(id)}" href="#fn-#{normalize_id(id)}" class="noteref" epub:type="noteref">*#{@chapter.footnote(id).number}</a>)
      else
        %Q(<a id="fnb-#{normalize_id(id)}" href="#fn-#{normalize_id(id)}" class="noteref">*#{@chapter.footnote(id).number}</a>)
      end
    rescue KeyError
      error "unknown footnote: #{id}"
    end
```

「`<†番号>`」になるように変更してみます。review-ext.rb を以下のように書きます。

```
module ReVIEW
  module HTMLBuilderOverride
    def inline_fn(id)
      if @book.config['epubversion'].to_i == 3
        %Q(<a id="fnb-#{normalize_id(id)}" href="#fn-#{normalize_id(id)}" class="noteref" epub:type="noteref">&lt;†#{@chapter.footnote(id).number}&gt;</a>)
      else
        %Q(<a id="fnb-#{normalize_id(id)}" href="#fn-#{normalize_id(id)}" class="noteref">&lt;†#{@chapter.footnote(id).number}&gt;</a>)
      end
    rescue KeyError
      error "unknown footnote: #{id}"
    end
  end

  class HTMLBuilder
    prepend HTMLBuilderOverride
  end
end
```

元々のメソッドの挙動を呼び出したいときには、`super` メソッドを使います。文字列が返ってくるので、必要に応じて加工し、また文字列を返すようにします。上記のコードを単純な文字列置換に変えてみた例を示します。

```
module ReVIEW
  module HTMLBuilderOverride
    def inline_fn(id)
      super(id).sub('>*', '>&lt;†').sub('</a>', '&gt;\&')
    end
  end

  class HTMLBuilder
    prepend HTMLBuilderOverride
  end
end
```

## 既存の命令の書き換え（ブロック命令）

ブロック命令の書き換えも、同名のメソッドおよび同じ数の引数で定義し直すだけです。`//footnote` 命令側の脚注記号も変えてみましょう。`HTMLBuilder` での実装は以下のようになっています。

```
    def footnote(id, str)
      if @book.config['epubversion'].to_i == 3
        puts %Q(<div class="footnote" epub:type="footnote" id="fn-#{normalize_id(id)}"><p class="footnote">[*#{@chapter.footnote(id).number}] #{compile_inline(str)}</p></div>)
      else
        puts %Q(<div class="footnote" id="fn-#{normalize_id(id)}"><p class="footnote">[<a href="#fnb-#{normalize_id(id)}">*#{@chapter.footnote(id).number}</a>] #{compile_inline(str)}</p></div>)
      end
    end
```

先ほどの review-ext.rb に上書きのメソッドを追加します。

```
module ReVIEW
  module HTMLBuilderOverride
    def inline_fn(id)
      if @book.config['epubversion'].to_i == 3
        %Q(<a id="fnb-#{normalize_id(id)}" href="#fn-#{normalize_id(id)}" class="noteref" epub:type="noteref">&lt;†#{@chapter.footnote(id).number}&gt;</a>)
      else
        %Q(<a id="fnb-#{normalize_id(id)}" href="#fn-#{normalize_id(id)}" class="noteref">&lt;†#{@chapter.footnote(id).number}&gt;</a>)
      end
    rescue KeyError
      error "unknown footnote: #{id}"
    end

    def footnote(id, str)
      if @book.config['epubversion'].to_i == 3
        puts %Q(<div class="footnote" epub:type="footnote" id="fn-#{normalize_id(id)}"><p class="footnote">&lt;†#{@chapter.footnote(id).number}&gt; #{compile_inline(str)}</p></div>)
      else
        puts %Q(<div class="footnote" id="fn-#{normalize_id(id)}"><p class="footnote">&lt;<a href="#fnb-#{normalize_id(id)}">†#{@chapter.footnote(id).number}</a>&gt; #{compile_inline(str)}</p></div>)
      end
    end
  end

  class HTMLBuilder
    prepend HTMLBuilderOverride
  end
end
```

インライン命令と異なり、ブロック命令では戻り値はなく、`puts`（改行あり）または`print`（改行なし）メソッドを使って結果を直接に出力します……正確に言うと、デフォルトの `puts/print` メソッドを書き換えて、StringIO クラスの `@output` というオブジェクト（擬似的にファイルのように見せたオブジェクト）に追加書き出しをしています。

このため、`super` メソッドで元々のメソッドの挙動を呼び出して結果を受け取る、ということが困難です。一般的な書き方としては、`super` メソッドを使わず、元々のメソッドを丸ごとコピーして必要な箇所を書き換える、ということになるでしょう。

## 初期化の追加

各ビルダでは、変換前に `builder_init_file` という初期化メソッドが最初に呼び出されます。何らかのフラグやカウンタを追加したり、ネットワークやデータベース、ローカルファイルからデータを読み込んだりといった処理をしたいときには、この初期化メソッドに処理を追加します。

LaTeX で初出の `@<img>` 参照箇所は太字にする（最初に「図1.1」という参照が出たところを太字にし、以降は「図1.1」と出ても地のままにする）という例を示します。

```
module ReVIEW
  module LATEXBuilderOverride
    def builder_init_file
      super
      @img_used = {}
    end

    def inline_img(id)
      s = super(id)
      if @img_used[id]
        s
      else
        @img_used[id] = true
        "{\\bfseries\\sffamily #{s}}"
      end
    end
  end

  class LATEXBuilder
    prepend LATEXBuilderOverride
  end
end
```

1点注意として、review-epubmaker や review-pdfmaker などのコマンド内では、各章（re ファイル）について毎回ビルダが呼ばれます。ネットワークからデータセットをダウンロードするといったケースでは、ダウンロード済みかどうかを判定するロジックを入れたり、初期化側ではなく maker の提供するフック（[フックで LaTeX 処理に割り込む](../latex/tex-hook.html) を参照）で事前ダウンロードをするようにしたりといった対処が必要になるかもしれません。

## 結果全体の書き換え

LaTeX 変換のデフォルトで使われる upLaTeX コンパイラは UTF-8 に対応していますが、UTF-8 のすべての文字が使えるというわけではありません。たとえば絵文字の領域は利用できないので、文中の「🍣」（Ux1f363、寿司）は変換すると空白文字の扱いになってしまいます。

手軽な対策として、🍣に対応する画像ファイルを用意しておき、変換時にこれを使うように置換することを考えます。

各ビルダの変換の最終結果の文字列は、`result` メソッドの返り値が書き出されます。たとえば builder.rb では以下のように定義されています。

```
    def result
      solve_nest(@output.string)
    end
```

`LATEXBuilder` もこれをそのまま継承しています（`HTMLBuilder` と `IDGXMLBuilder` はもう少し追加の処理をしています）。`@output` はブロック命令でも言及した StringIO クラスのオブジェクトで、ビルダ内で `puts` あるいは `print` で吐き出した結果文字列がここに蓄積されています。`string` メソッドで全文字列を取り出し、最終結果として返します。

この最終結果に画像化のための置換工程を1つ加えます。

```
module ReVIEW
  module LATEXBuilderOverride
    def result
      super.gsub('🍣', '\includegraphics[width=1zw]{images/1f363.pdf}')
    end
  end

  class LATEXBuilder
    prepend LATEXBuilderOverride
  end
end
```

## 命令の追加（インライン命令）

インライン命令を新たに追加するには、Compiler クラスの `definline` メソッドを使って宣言します。たとえば `Builder` に `kaibun` という文字列を逆転させるインライン命令を追加してみましょう。

```
module ReVIEW
  module BuilderOverride
    Compiler.definline :kaibun

    def inline_kaibun(s)
      s.reverse
    end
  end

  class Builder
    prepend BuilderOverride
  end
end
```

これで、`@<kaibun>{あいうえお}` のように re ファイルに記述すると、「おえういあ」と表現されます。全ビルダに共通する命令を追加したいときには、基底となる `Builder` に追加する必要があります。

インライン命令は1つの文字列を引数に取ります。`kw` や `ruby` のような引数を複数取っているように見える命令を実現するには、メソッドの実装ロジック内で引数の文字列を自前で分解し、解釈する必要があります。

## 命令の追加（ブロック命令）

ブロック命令の追加も Compiler クラスのメソッドを使って宣言しますが、ブロックのコンテンツ（`{ 〜 //}`）を取るかどうかで使うメソッドが異なります。

- コンテンツを取る：`defblock` メソッド
- コンテンツを取らない：`defsingle` メソッド（`footnote` など）

宣言記法は以下のとおりです。

```
Compiler.defblock :命令名, オプション数 [, ブロックなし許容]
Compiler.defsingle :命令名, オプション数
```

オプション数に、ブロック命令が取るパラメータ（`[ ]` で記述するもの）の数を指定します。何も取らないなら `0`、1つ取るなら `1`、あるいは0〜2個まで取る可能性があるなら `0..2` のように可変長の数も指定できます。

`defblock` では、「ブロックなし許容」のところに `true` を指定すると、ブロックコンテンツ（`{ 〜 //}`）を省略することもできるようになります。デフォルトは `false` で、ほとんどのブロック命令ではブロックコンテンツを取ることが要求されています。

`HTMLBuilder` に `marquee` というブロック命令を追加してみます。この命令は HTML の marquee タグに展開されます。0 または 1 つのオプションを取り、オプションが指定されたらそのまま behavior 属性に渡すようにします。

```
module ReVIEW
  module IndexBuilderOverride
    Compiler.defblock :marquee, 0..1

    def marquee(lines, behavior=nil)
      # nil
    end
  end

  class IndexBuilder
    prepend IndexBuilderOverride
  end

  module HTMLBuilderOverride
    Compiler.defblock :marquee, 0..1

    def marquee(lines, behavior=nil)
     opt = ''
     opt = %Q( behavior="#{behavior}")
     puts "<marquee#{opt}>#{split_paragraph(lines).join("\n")}</marquee>"
    end
  end

  class HTMLBuilder
    prepend HTMLBuilderOverride
  end
end
```

Re:VIEW 5.0 以降において、あるビルダ向けに命令を新設したときには、中身は適当でよいので `IndexBuilder`、または全ビルダの基底クラスである `Builder` にも定義が必要です。上記では `IndexBuilder` に追加しました。

ブロック命令の実装用メソッド（ここでは `marquee`）の1つめの引数にブロックコンテンツが渡されます。`split_paragraph` はコンテンツを空行を段落の区切りと見なして段落に分割するメソッドです。

以下のように re ファイルに書いて `rake web` を実行して結果を見てみましょう（超ウザいですね！！）。

```
//marquee{
たのしい！

たのしい！
//}

//marquee[alternate]{
たのしい！

たのしい！
//}
```

## その他の拡張

より高度な命令を作りたいという場合には、Re:VIEW の完全なコードリーディングが必要になるでしょう。いくつかのヒントを提示しておきます。

- 相互参照可能なカウンタを持つブロック要素を追加したい：Index クラスを継承したカウンタの定義や、初期化ロジックへの追加、参照インライン命令での他章参照時の処理など、広範囲での作業が必要です。また、カウンタ収集時のロジックの理由で、ブロック命令の名前の始まが既存のブロック命令の始まりと重ならないようにする必要があります（たとえば `image2` といった名前だと既存の `image` にカウンタ収集を奪われて動作しない）。`image` や `list` の実装を追跡してみてください。
- コラムのようなパターンを追加したい：これは実は簡単で、`XX_begin(level, label, caption)` と `XX_end(level)` の対となるメソッドを定義しておけば、`==[XX]` の新たな見出し記法ができあがります。
- 「1.」や「*」のような箇条書きを追加したい：ビルダではなく、コンパイラ（Compiler クラスの `do_compile` メソッド）を書き換える必要があります。フックのような後処理で対応したほうが妥当かもしれません。
