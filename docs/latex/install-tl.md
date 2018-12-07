2018/12/6 by @kmuto

# Re:VIEW 向け日本語 TeXLive 環境のセットアップ（Unix、macOS）

OS のパッケージに頼らず、TeXLive の最新版をインストールする方法を説明します。

----

[TeXLive](https://www.tug.org/texlive/) は、TeX とそれにまつわる環境一式を提供する巨大な集合体です。

インストールに必要な作業自体はそう難しくはないのですが、デフォルトでは「すべて」をインストールしようとするために膨大な容量と時間を消費するほか、ネットワークからのダウンロードではエラーで失敗することも多々あります。日本語で Re:VIEW を利用する上では使わないファイルも大量です。

ここでは「Re:VIEW の PDF 変換が通りさえすればよい」という割り切りのもとで TeXLive のセットアップ手順を紹介します。

## Debian GNU/Linux または Ubuntu Linux の場合（OS パッケージの利用）
Debian GNU/Linux、Ubuntu Linux の場合は、現時点でも TeXLive 2016 あるいは TeXLive 2018 が deb パッケージとしてそれぞれのディストリビュータから提供されているので、これを使うのが最も簡単です。

なるべく最小に絞ったパッケージ選定としては以下のようになります（これは [Re:VIEW image for Docker](https://hub.docker.com/r/vvakame/review/) 版でも選定しているものです）。

```
$ sudo apt-get install texlive-lang-japanese texlive-fonts-recommended \
  texlive-latex-extra lmodern fonts-lmodern tex-gyre fonts-texgyre \
  texlive-pictures ghostscript gsfonts
```

日本語フォントの埋め込みはデフォルトでなしになっています。ひとまず IPA フォントを設定するには次のようにします。

```
$ sudo kanji-config-updmap-sys ipaex
```

Google の [Noto](https://www.google.com/get/noto/) フォントを利用したい場合は、次の手順で進めます（Docker 版ではすでにこれが構成されています）。

Debian GNU/Linux Stretch の場合はセリフ体がまだ収録されていない版なので、バックポートリポジトリを有効にします。

```
$ sudo sh -c "echo 'deb http://ftp.jp.debian.org/debian/ stretch-backports main' >> /etc/apt/sources.list.d/backports.list"
$ sudo apt-get update
```

Noto フォントパッケージをインストールします。

```
apt-get -y install fonts-noto-cjk/stretch-backports fonts-noto-cjk-extra/stretch-backports （Debian Stretch の場合）
apt-get -y install fonts-noto-cjk fonts-noto-cjk-extra （Ubuntu や Debian Buster 以降の場合）
```



## TeXLive のインストール（自身で選定する方法）
TeXLive のインストーラは install-tl という名前のファイルです。Linux・macOS いずれでも、[サイト](https://www.tug.org/texlive/acquire-netinstall.html)から「install-tl-unx.tar.gz」をダウンロードします。

ここではホームの Download フォルダにダウンロードしたとします。ターミナルを開いて以下のように tar.gz アーカイブファイルを展開し、そのフォルダに移動します。

```
$ cd ~/Download
$ tar xvf install-tl-unx.tar.gz
install-tl-20181205/...
 ...
$ cd install-tl-*
```

次に、この中の install-tl を root 権限で実行します。このとき、ダウンロードリポジトリを指定できます。デフォルトのままだと CDN のミラーサイトになるのですが、TeXLive のミラーサイトの品質はバラバラで、速度が出なかったり、はたまたミラーがちゃんとできていなかったりなどのつまらない問題にひっかかることが多いため、最も安定していて速度も出る JAIST を選んでいます。

```
sudo ./install-tl --repository http://ftp.jaist.ac.jp/pub/CTAN/systems/texlive/tlnet/
```

17.58.03.png

テキストベースのインストーラの画面が開きます。デフォルトではスキームに scheme-full が選択されていて、すべてのパッケージファイルがインストールされてしまう（5.6GB にもなる）ので、まずはこれを変更します。

メニューにあるとおり `S` と入れて Enter キーを押します。

17.58.12.png

スキームの選択になります。TeX のスタイルなど個々の機能や拡張はパッケージとして配布されています。TeXLive ではこのパッケージを言語あるいは TeX コンパイラなどの目的単位にグループ化し、コレクションと呼んでいます。さらにこのコレクションを、依存関係も考慮してユーザー向けにもう少しわかりやすい選択肢としてまとめたものがスキームです。

ここではスキームを最小のものにするために「e. minimal scheme」を選ぶことにします。`e`、Enter キーと押します。これで e 行が `[X]` となるので、`R`、Enter キーと押してメニューに戻ります。

メインメニューから今度はコレクションを選ぶため、`C`、Enter キーと押します。

コレクションの一覧が表示されます。スキームを最小にしたので、「a. Essential programs and files」だけに `[X]` とチェックが付いている状態です。Re:VIEW で日本語利用を使う範囲で見回して、以下を使うことにします。「fundamental」のように外すとまずいのでは？と怖くなるかもしれませんが、依存関係でこれらは自動で選ばれるので問題ありません。

- c. TeX auxiliary programs
- f. Recommended fonts
- x. Japanese （依存関係で m. Chinese/Japanese/Korean (base) も入る）
- E. LaTeX additional packages （依存関係で F. LaTeX recommended packages、D. LaTeX fundamental packages も入る）

これらにチェックを付けるため「`cfxE`」とまとめて記入し、Enter キーを押します。

22.40.03.png

- コレクションの選定は、@munepixyz さんが作られている[最小プロファイル](https://gist.github.com/munepi/cb7999cb0f4d0c8629d1593fe3117e33)を参考にしました。
- XeTeX パッケージは過去 dvipdfmx の実行に必要でしたが、整理されて dvipdfmx パッケージが基本コレクションに収録されるようになったので、XeTeX を使うのでなければ選択する必要はなくなっているようです。

必要であればほかに以下を加えるのもよいでしょう。

- e. Additional fonts：いろいろな欧文フォントを利用したい場合
- G. LuaTeX packages: LuaTeX を使いたい場合

`R`、Enter キーと押してメインメニューに戻ります。

次はオプションを設定します。`O`、Enter キーでオプションメニューに移動します。

22l.40.42

以下の2つのオプションは TeX のドキュメントやソースコードのインストール設定ですが、Re:VIEW から TeX を利用するだけであれば使うことがないでしょう（レイアウトをいろいろ変更したいというときには、ネットのつまみ食いではなく、これらのオプションはそのままにしておくべきです！ `texdoc` コマンドを使って TeX のドキュメントを参照できます）。

- D. install font/macro doc tree
- S. install font/macro source tree

`D`、Enter キー、`S`、Enter キーでチェックを外し、`R`、Enter キーでメインメニューに戻ります。

これで Re:VIEW を動かすに足る最小構成ができました。`I`、Enter キーでダウンロードとインストールを実行します。

22.42.13

ブロードバンドであれば、20〜30分ほどでダウンロードとセットアップが完了します。

18.21.31

最後のメッセージにあるとおり、プログラムは `/usr/local/texlive/<TeXLiveバージョン>/bin/<アーキテクチャ名>` フォルダに用意されるので、ここにパスを通す必要があります。たとえば次のようにホームフォルダの `.bashrc` に追加します（これはパスの先頭に TeXLive へのパスを通します）。

```
$ echo "PATH=/usr/local/texlive/2018/bin/x86_64-darwin:$PATH" >> ~/.bashrc
```

ターミナルを開き直し、TeXLive がインストールされていることを確認しましょう。

```
$ uplatex --version
e-upTeX 3.14159265-p3.8.1-u1.23-180226-2.6 (utf8.uptex) (TeX Live 2018)
kpathsea version 6.3.0
ptexenc version 1.3.6
Copyright 2018 D.E. Knuth.
There is NO warranty.  Redistribution of this software is
covered by the terms of both the e-upTeX copyright and
the Lesser GNU General Public License.
For more information about these matters, see the file
named COPYING and the e-upTeX source.
Primary author of e-upTeX: Peter Breitenlohner.
```

Re:VIEW のプロジェクトで `rake pdf` を実行して、正常に PDF が生成されることも確認します。

## フォントの設定（macOS）

生成される PDF の日本語フォントには、デフォルトで IPA フォントが割り当てられています。せっかくの macOS のヒラギノフォントを活かすには、もう少し設定が必要です。商業フォントのように外部のファイルを使用するパッケージは TeXLive の主リポジトリとは分離された TLContrib というリポジトリに置かれています。

- 以下の内容は、TeX Wiki の記事[TLContrib](https://texwiki.texjp.org/?TLContrib) をもとにしています。

まずそのリポジトリを使うよう tlmgr コマンドで設定します。

```
$ sudo tlmgr repository add http://contrib.texlive.info/current tlcontrib
$ sudo tlmgr pinning add tlcontrib '*'
```

続いてパッケージをインストールします。

```
$ sudo tlmgr install japanese-otf-nonfree japanese-otf-uptex-nonfree ptex-fontmaps-macos cjk-gs-integrate-macos
```

念のために、フォントのリンクファイルやエイリアスファイルなどを綺麗にします。

```
$ sudo cjk-gs-integrate --link-texmf --cleanup
```

そして、macOS のシステムのフォントファイルを TeXLive から利用できるようにリンクします（`-macos` と付くことに注意してください）。

```
$ sudo cjk-gs-integrate-macos --link-texmf
```

リンクしたファイルを TeX のプログラムから見つけられるよう、ファイルデータベースを更新します。

```
$ sudo mktexlsr
```

これで準備ができました。次に kanji-config-updmap-sys コマンドでヒラギノを利用するよう設定しますが、macOS のバージョンによりマップ名が異なります。

High Sierra 以降の場合：
```
$ sudo kanji-config-updmap-sys --jis2004 hiragino-highsierra-pron

```

Sierra 以前の場合：
```
$ sudo kanji-config-updmap-sys --jis2004 hiragino-elcapitan-pron
```

これで出来上がりです。Re:VIEW プロジェクトをコンパイルして、書体が変わることを確認しましょう。

小塚やモリサワのフォントを購入あるいは購読しているならば、それを使うこともできます。システムにこれらのフォントが入っていれば、cjk-gs-integrate-macos コマンドの実行で /usr/local/texlive/texmf-local/fonts/opentype/cjk-gs-integrate フォルダにフォントファイルへのリンクができています。

kanji-config-updmap-sys コマンドの status オプションで利用可能か調べられます。

```
$ sudo kanji-config-updmap-sys status
CURRENT family for ja: hiragino-elcapitan-pron
Standby family : hiragino-elcapitan
Standby family : ipa
Standby family : ipaex
Standby family : kozuka
Standby family : kozuka-pr6n
Standby family : morisawa
Standby family : morisawa-pr6n
Standby family : ms-osx
Standby family : toppanbunkyu-sierra
```

変更するには表示されているファミリ名を指定します。以下ではモリサワ Pr6N ファミリに変更しています。

```
$ sudo kanji-config-updmap-sys morisawa-pr6n
```

## フォントの設定（Linux）

Linux でもおおむね macOS と考え方は同じですが、cjk-gs-integrate-macos は用意されていません。

小塚やモリサワのフォントを購入あるいは購読しているならば、macOS の手順と同じように TLContrib から japanese-otf-nonfree および japanese-otf-uptex-nonfree パッケージをインストールします。

/usr/local/texlive/texmf-local/fonts/opentype/morisawa などを作って、使用権を持つフォントファイルを配置あるいはシンボリックリンクを張ったら、

