2018/8/9 by @kmuto

# 図表のフロートを制御する

LaTeX において、キャプション付きの図や表は、「フロート」という1つのかたまりして扱われます。その名のとおり浮動的なもので、本文とはいくぶん切り離されて、版面上に空いている箇所に配置されます。

Re:VIEW のデフォルトのスタイルでは、このフロートは以下の挙動になるように定義しています。

- 図：必ず指定した位置に配置。入らなければ大きな余白を恐れずに改ページして配置
- 表：指定した位置に「配置できそうなら」配置。入らなければ次ページ先頭に配置し、表の後ろにあった文は余白を埋めるまで入る

★絵がほしい

この挙動により、次のような場面で悩むことになるかもしれません。

- 表が次のページに行きやすい
- 図の下に余白ができやすい
- 図表は必ず版面上端に揃えたいのにできない

スタイルの図表のフロートの挙動を定義し直すことで、これらの問題に対処することができます。

Re:VIEW 2 ベースの場合は `table_header` メソッドに `[h]` が決めうちで記述されてしまっているので、次のような review-ext.rb をプロジェクトフォルダに置いて上書きします。
★Re:VIEW 3は#1095

```
module ReVIEW
  module LATEXBuilderOverride
    def table_header(id, caption)
      # \begin{table}[h]の[h]を削除
      if id.nil?
        if caption.present?
          @table_caption = true
          @doc_status[:caption] = true
          puts "\\begin{table}%%#{id}"
          puts macro('reviewtablecaption*', compile_inline(caption))
          @doc_status[:caption] = nil
        end
      else
        if caption.present?
          @table_caption = true
          @doc_status[:caption] = true
          puts "\\begin{table}%%#{id}"
          puts macro('reviewtablecaption', compile_inline(caption))
          @doc_status[:caption] = nil
        end
        puts macro('label', table_label(id))
      end
    end
  end

  class LATEXBuilder
    prepend LATEXBuilderOverride
  end
end
```

Re:VIEW 2 系の場合はプロジェクトフォルダの sty/reviewmacro.sty に以下のように記述します。

```
\renewenvironment{reviewimage}{%
  \begin{figure}
    \begin{center}}{%
    \end{center}
  \end{figure}}

\floatplacement{table}{H}
\floatplacement{figure}{H}
```

Re:VIEW 3 以上の場合はプロジェクトフォルダの sty/review-custom.sty に以下のように記述します。★Re:VIEW 3は#1095

```
\floatplacement{table}{H}
\floatplacement{figure}{H}
```

table が表の指定、figure が図の指定で、「H」となっているのが位置指定です。

- H：絶対に指定箇所に置く（float.sty の効果）
- h：できれば指定箇所に置く。少しでも無理ならあきらめて次の候補へ
- t：版面上端に置く
- b：版面下端に置く
- p：単独のページに置く

デフォルトでは図は「H」、表は「h（挙動としてはhtp）」が指定されていました。フロートは必ず上端に置く、という設定にしたければ次のようになります。

```
\floatplacement{table}{t}
\floatplacement{figure}{t}
```

箇所によって調整したい場合は、`table_header` メソッドや `image_image` メソッドに渡される変数 `id` をチェックして位置指定を上書きする（特定の `id` 値のときだけ `\begin{table}[t]` にするなど）ロジックを実装することになるでしょう。

フロートの挙動はなかなか厄介で、少し文字の調整をしたつもりが後続のフロート要素に影響して調整し直しになってしまうことがままあります。印刷の結果を最優先にするのであれば、図も表もどちらも「H」に設定しておき、re ファイル側で図表の位置を変えてしまったほうが扱いやすいかもしれません。

また、h・t・b・p指定による自動配置の場合、たまに流れが詰まって章の最後で吐き出されてしまったりすることがあります。途中で強制的に吐き出すには、`\clearpage` 命令を適宜埋め込む必要があります。

```
//raw[\clearpage\n]
```
