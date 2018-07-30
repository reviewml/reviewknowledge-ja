2017/7/30 by @kmuto

# Re:VIEW のモンキーパッチによる拡張の基本

`review-ext.rb` をプロジェクトに置くことで、Re:VIEW のロジックを上書きできます。新しい命令を追加したり、既存の命令の挙動を変更したりするのに使えます。

----
プロジェクトに `review-ext.rb` という名前のファイルを置くと、review-pdfmaker などの Re:VIEW の各コマンドの実行時にこのファイルが取り込まれ、Re:VIEW 自身が書き換えられます。

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

ビルダとは、原稿ファイル (.re) から変換するルールおよび手続きを定義したクラスです。Re:VIEW がサポートする変換形式に合わせて、代表としては以下のものがあります。

- `Builder`: 以下の各ビルダの基底クラス。主に全ビルダに新規の命令を追加したいときにこれを拡張することになるでしょう。
- `HTMLBuilder`: epubmaker や webmaker で使っている HTML 変換のビルダクラス。
- `LATEXBuilder`: pdfmaker で使っている LaTeX 変換のビルダクラス。
- `IDGXMLBuilder`: InDesign XML 変換のビルダクラス。
- `TOPBuilder`: textmaker で使っている装飾付きプレインテキスト変換のビルダクラス。
- `PLAINTEXTBuilder`: textmaker で使っている装飾なしプレインテキスト変換のビルダクラス。

各ビルダのクラス定義ファイルは、Re:VIEW ソースの `lib/review/` にあります。

ここでは全ビルダの基底クラスである `Builder` を `BuilderOverride` の定義内容で上書きする、ということになります (Ruby の `prepend` 命令が実際の上書きの調整をします) 。
