2017/7/30 by @kmuto

# @\<bidx\> などの装飾表示と索引を併せ持つインライン命令を追加する

太字出力＋索引語とする `@<bidx>` などのインライン命令を追加します。

----

Re:VIEW の索引用命令としては `@<hidx>{語句}` と `@<idx>{語句}` の2つを用意しています。前者は「語句」を単に索引に登録します（なお、pdfmaker 以外は、独自に後処理を加えない限り索引は機能しません）。これに対し、後者は索引に登録しつつ、紙面にも表示します。

```
@<hidx>{α}と@<idx>{β}
  ↓ これを変換すると……
とβ

索引
α  1
β  1
```

実装者としては「idx」というのはあまり名前がよくなかったな、と反省があるのですが、意外と便利に使っている方もいらっしゃるようです。

ただ、Re:VIEW は現状ではインライン命令を入れ子にすることはできないため、`@<b>{語句}` などの装飾された語句に対して `@<idx>` を使うことはできず、`@<b>{語句}` の前なり後なりに別途 `@<hidx>{語句}` を置く必要があります。

```
× @<b>{@<idx>{太字語句}}
○ @<hidx>{太字語句}@<b>{太字語句}
```

そこで、`@<bidx>{太字語句}` で上記相当を実現できるようにしてみます。ついでに `@<iidx>`、`@<ttidx>` も追加してしまいましょう（……といったように装飾の数だけ増えてしまう上にわかりにくいので、ちょっと Re:VIEW のコアには入れづらいのでした）。

`review-ext.rb` は次のようになります。

```
module ReVIEW
  module BuilderOverride
    # bidx, iidx, ttidx 命令を追加
    Compiler.definline :bidx
    Compiler.definline :iidx
    Compiler.definline :ttidx

    def inline_bidx(s)
      inline_hidx(s) + inline_b(s)
    end

    def inline_iidx(s)
      inline_hidx(s) + inline_i(s)
    end

    def inline_ttidx(s)
      inline_hidx(s) + inline_tt(s)
    end
  end

  class Builder
    prepend BuilderOverride
  end
end
```

これで、どのビルダにも適用される `@<bidx>`、`@<iidx>`、`@<ttidx>` ができました。

```
@<bidx>{BOLD}, @<iidx>{ITALIC}, @<ttidx>{TYPEWRITER}
 ↓ LaTeX変換
\index{BOLD}\reviewbold{BOLD}, \index{ITALIC}\reviewit{ITALIC}, \index{TYPEWRITER}\reviewtt{TYPEWRITER}
```

なお、基本的にはこのように索引登録が前、表示語句が後の順序にするのが適切です。さもないと、表示語句の途中でページが変わった場合、索引の参照先が分断された後ろ側のページになってしまうからです（Re:VIEW 3.0.0preview1 時点ではこれが逆になっているので、適切なほうに修正するか考え中です）。

ただし段落開始直後の場合は、表示語句が前、索引登録が後の順序のほうが安全です。その段落がページの先頭に配置される場合、索引の参照先が1つ前のページに置かれてしまう可能性があります。
