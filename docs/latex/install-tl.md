2018/12/6, 2018/12/9, 2018/12/10, 2018/12/15 by @kmuto

# Re:VIEW 向け日本語 TeX Live 環境のセットアップ（Linux、macOS、Windows）

OS のパッケージに頼らず、TeX Live の最新版をインストールする方法を説明します。

----

[TeX Live](https://www.tug.org/texlive/) は、TeX とそれにまつわる環境一式を提供する巨大な集合体です。

インストールに必要な作業自体はそう難しくはないのですが、デフォルトでは「すべて」をインストールしようとするために膨大な容量と時間を消費するほか、ネットワークからのダウンロードではエラーで失敗することも多々あります。日本語で Re:VIEW を利用する上では使わないであろうファイルもたくさんあります。

ここでは「Re:VIEW の PDF 変換が通りさえすればよい」という割り切りのもとで TeX Live のセットアップ手順を紹介します。

- 執筆時点の TeX Live 2018 に基づいています。
- Debian GNU/Linux・Ubuntu Linux、macOS、Windows 10 を前提にしています。
- TeX コンパイラには upLaTeX を利用することを前提とします。特にフォントの設定については LuaLaTeX のほうがシステムフォントの探索などでのトラブルが少ないのですが、現状の Re:VIEW の基本設定では upLaTeX コンパイラをデフォルトとしています。
- Debian GNU/Linux、Ubuntu Linux で OS のパッケージを利用して最小構成を構築したい場合は、[Re:VIEW image for Docker](https://hub.docker.com/r/vvakame/review/) の Dockerfile の内容が参考になるでしょう。

説明の都合で、Windows のインストールは本記事の後のほうに記しています。

## TeX Live のインストール（Linux・macOS）
TeX Live のインストーラは `install-tl` という名前のファイルです。Linux・macOS いずれでも、[サイト](https://www.tug.org/texlive/acquire-netinstall.html)から「install-tl-unx.tar.gz」をダウンロードします。

ここではホームの `Download` フォルダにダウンロードしたとします。ターミナルを開いて以下のように tar.gz アーカイブファイルを展開し、そのフォルダに移動します。

```
$ cd ~/Download
$ tar xvf install-tl-unx.tar.gz
install-tl-20181205/...
 ...
$ cd install-tl-*
```

次に、この中の `install-tl` を root 権限で実行します。

```
$ sudo ./install-tl
```

（最近は安定していて再現性がないのですが、このあとの工程でパッケージのダウンロードおよび検証に失敗するようであれば、ダウンロード先を明示してみると解決するかもしれません。たとえば JAST ミラーであれば、`sudo ./install-tl --repository http://ftp.jaist.ac.jp/pub/CTAN/systems/texlive/tlnet/` と指定します。）

![TeX Live インストーラメインメニュー](images/tl-menu1.png)

テキストベースのインストーラの画面が開きます。デフォルトではスキームに scheme-full が選択されていて、すべてのパッケージファイルがインストールされてしまう（5.6GB にもなる）ので、まずはこれを変更します。

メニューにあるとおり `S` と入れて Enter キーを押します。

スキームの選択になります。TeX のスタイルなど個々の機能や拡張はパッケージとして配布されています。TeX Live ではこのパッケージを言語あるいは TeX コンパイラなどの目的単位にグループ化し、コレクションと呼んでいます。さらにこのコレクションを、依存関係も考慮してユーザー向けにもう少しわかりやすい選択肢としてまとめたものがスキームです。

ここではスキームを最小のものにするために「e. minimal scheme」を選ぶことにします。`e`、Enter キーと押します。これで e 行が `[X]` となるので、`R`、Enter キーと押してメニューに戻ります。

![スキームの選択](images/tl-menu2.png)

メインメニューから今度はコレクションを選ぶため、`C`、Enter キーと押します。

コレクションの一覧が表示されます。スキームを最小にしたので、「a. Essential programs and files」だけに `[X]` とチェックが付いている状態です。Re:VIEW で日本語利用を使う範囲で見回して、以下を使うことにします。「fundamental」のように外すとまずいのでは？ と怖くなるかもしれませんが、依存関係でこれらは自動で選ばれるので問題ありません。

- c. TeX auxiliary programs
- f. Recommended fonts
- x. Japanese （依存関係で m. Chinese/Japanese/Korean (base) も入る）
- E. LaTeX additional packages （依存関係で F. LaTeX recommended packages、D. LaTeX fundamental packages も入る）

これらにチェックを付けるため「`cfxE`」とまとめて記入し、Enter キーを押します。

![コレクションの選択](images/tl-menu3.png)

必要であればほかに以下を加えるのもよいでしょう。

- e. Additional fonts：いろいろな欧文フォントを利用したい場合
- G. LuaTeX packages: LuaTeX を使いたい場合

`R`、Enter キーと押してメインメニューに戻ります。

次はオプションを設定します。`O`、Enter キーでオプションメニューに移動します。

![オプションの設定](images/tl-menu4.png)

以下の2つのオプションは TeX のドキュメントやソースコードのインストール設定ですが、Re:VIEW から TeX を利用するだけであれば使うことがないでしょう（レイアウトをいろいろ変更したいというときには、これらのオプションはそのままにしておくべきです！ `texdoc` コマンドを使って TeX のドキュメントを参照できます。ネットのつまみ食いはお腹を壊します）。

- D. install font/macro doc tree
- S. install font/macro source tree

`D`、Enter キー、`S`、Enter キーでチェックを外し、`R`、Enter キーでメインメニューに戻ります。

これで Re:VIEW を動かすに足る最小構成ができました。`I`、Enter キーでダウンロードとインストールを実行します。ブロードバンドであれば、20〜30分ほどでダウンロードとセットアップが完了します。

![TeX Live のインストール完了](images/tl-menu5.png)

最後のメッセージにあるとおり、プログラムは `/usr/local/texlive/<TeX Liveバージョン>/bin/<アーキテクチャ名>` フォルダに用意されるので、ここにパスを通す必要があります。たとえば次のようにホームフォルダの `.bashrc` に追加します（これはパスの先頭に TeX Live へのパスを通します）。

```
$ echo "PATH=/usr/local/texlive/2018/bin/x86_64-darwin:$PATH" >> ~/.bashrc （macOSの場合）
$ echo "PATH=/usr/local/texlive/2018/bin/x86_64-linux:$PATH" >> ~/.bashrc （Linuxの場合）
```

ターミナルを開き直し、TeX Live がインストールされていることを確認しましょう。

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

- コレクションの選定は、@munepixyz さんが作られている[最小プロファイル](https://gist.github.com/munepi/cb7999cb0f4d0c8629d1593fe3117e33)を参考。
- XeTeX パッケージは過去 `dvipdfmx` コマンドの実行に必要だったが、整理されて dvipdfmx パッケージが基本コレクションに収録されるようになったので、XeTeX を使うのでなければ選択する必要はなくなっている模様。

## Ghostscript のインストール（Linux・macOS）

以降のフォントの自動設定をしたかったり、あるいはドキュメント内で eps 形式のファイルを使いかったりするときには、TeX Live とは別に、Postscript インタプリタの Ghostscript が必要です。

Debian GNU/Linux や Ubuntu Linux の場合は deb パッケージをインストールします。

```
$ sudo apt-get install ghostscript
```

macOS の場合は [Homebrew](https://brew.sh/index_ja) を導入した上でインストールするのがよいでしょう。

```
$ brew install ghostscript
```

- Ghostscriptなしでフォント自動設定機能だけを使う方法（Re: MacのTexliveインストールの際のシンボリックリンクの貼り直しがうまくいかない）: [https://oku.edu.mie-u.ac.jp/tex/mod/forum/discuss.php?d=2229#p13069](https://oku.edu.mie-u.ac.jp/tex/mod/forum/discuss.php?d=2229#p13069)

## パッケージの追加と TeX Live の更新
後からパッケージが必要になったり、あるいは不要になったので削除したかったりといったときの TeX Live のパッケージ管理は `tlmgr` コマンドで行います。

また、本記事でインストールされる TeX Live は「開発の最新」のものであるため、まれに「壊れていて奇妙なエラーになる」ものがインストールされることがあります。たいていは該当のマクロパッケージの更新で修正されます。

```
sudo tlmgr アクション
```

よく使うであろうアクションを以下に示します。

- list：関知しているパッケージ一覧を表示します。頭に i が付いているのがインストール済みのパッケージです。
- info パッケージ名：パッケージの情報を表示します。
- install パッケージ名：パッケージをインストールします。
- remove パッケージ名：パッケージを削除します。
- search 検索語句：検索語句をパッケージ名や説明に含むパッケージを探します。
- update --list：更新可能なパッケージを報告します。
- update --all：更新可能なパッケージの更新を実行します。
- update --self：tlmgr 自体を更新します。

コレクションやスキームもパッケージの一種なので、`tlmgr install collection-コレクション名` や `tlmgr install scheme-スキーム名` でまとめてインストールすることも可能です。

Linux で `sudo` コマンドを使う場合、secure_path 設定に TeX Live のパスを追加する必要があるかもしれません。`visudo` コマンドで以下のようにパスを加えておきましょう。

```
Defaults  secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
 ↓
Defaults  secure_path="/usr/local/texlive/2018/bin/x86_64-linux:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
```

## フォントの設定（macOS）

生成される PDF の日本語フォント（リュウミンや中ゴシックなど）の代替書体には、デフォルトで IPA フォントが割り当てられています。macOS のシステムにデフォルトでインストールされているヒラギノフォントを利用するには、もう少し設定が必要です。

現時点で macOS で最も手軽にヒラギノフォントを設定する方法として、@munepixyz さんが作成されている「[［改訂第7版］LaTeX2e美文書作成入門 ヒラギノフォントパッチ](https://github.com/munepi/bibunsho7-patch)」があります。名前からは『LaTeX2e美文書作成入門』（技術評論社）専用ツールに見えますが、`install-tl` で構築した TeX Live 環境にもそのまま適用可能です。

パッチリリースページ [https://github.com/munepi/bibunsho7-patch/releases](https://github.com/munepi/bibunsho7-patch/releases) から、最新の dmg ファイルをダウンロードします。

![Bibunsho7-patchのダウンロード](images/patch1.png)

執筆時点では Bibunsho7-patch-1.3-20181128.dmg が最新だったので、これをダウンロードしました。ダウンロードした dmg ファイルを開き、この中の Patch.app を実行します。

ファイル情報が表示されますが、「Patchを開く」をクリックして進みます（このとき、インターネットからダウンロードしたアプリケーションへの警告が示されることがありますが、仕方がないので「開く」を押して進みます）。

![Patchの実行](images/patch2.png)

ヒラギノフォントの設定に必要な処理がひととおり行われ、終了すると「完了」と表示されます。

![ヒラギノフォントの自動設定処理](images/patch3.png)

これで、デフォルトの日本語はヒラギノの明朝・ゴシックに自動で切り替わります。

- 設定は `/usr/local/texlive/texmf-local` フォルダに対して行われます。
- macOS のヒラギノフォントの形式および置き方は、macOS の今後の更新によって変化する可能性があります。TeX Live 開発元はヒラギノフォントの利用を何ら推奨していないことに注意してください。

## フォントの設定（macOS＋一部手作業）

上記の Bibunsho7-patch の内部で実行されていることも含めて、パッチプログラムによらず手動で行う方法、および別のフォントセットに切り替える方法を説明します。

これには cjk-gs-integrate-macos というパッケージが便利です。外部の商業フォントファイルを使用する cjk-gs-integrate-macos のようなパッケージは、TeX Live の主リポジトリとは分離された TLContrib というリポジトリに置かれています。

まずそのリポジトリを使うよう `tlmgr` コマンドで設定します。

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

そして、macOS のシステムのフォントファイルを TeX Live から利用できるようにリンクします（`-macos` と付くことに注意してください）。

Mojave の場合：
```
$ sudo cjk-gs-integrate --fontdef-add=cjkgs-macos-highsierra.dat --link-texmf --force
```

Hight Sierra までの場合：
```
$ sudo cjk-gs-integrate-macos --link-texmf
```

リンクしたファイルを TeX のプログラムから見つけられるよう、ファイルデータベースを更新します。

```
$ sudo mktexlsr
```

これで準備ができました。次に `kanji-config-updmap-sys` コマンドでヒラギノを利用するよう設定しますが、macOS のバージョンによりマップ名が異なります。

High Sierra 以降の場合：
```
$ sudo kanji-config-updmap-sys --jis2004 hiragino-highsierra-pron
```

Sierra 以前の場合：
```
$ sudo kanji-config-updmap-sys --jis2004 hiragino-elcapitan-pron
```

- `--jis2004` オプションは、JIS2004 の例示字形を使う指定です（二点しんにょうなど）。
- 「pron」の pro は Adobe-Japan 1-4 以降準拠の文字セットに準拠しており、n は JIS2004 字形を使っているという意味です。一般には Adobe-Japan 1-6 準拠の Pr6 あるいは Pr6N のフォントを使うことになるでしょう。

これで出来上がりです。Re:VIEW プロジェクトをコンパイルして、書体が変わることを確認しましょう。

小塚やモリサワのフォントを購入あるいは購読しているならば、それを使うこともできます。システムにこれらのフォントが入っていれば、`cjk-gs-integrate-macos` コマンドの実行で `/usr/local/texlive/texmf-local/fonts/opentype/cjk-gs-integrate` フォルダにフォントファイルへのリンクができています。macOS のヒラギノフォントの置き方および字形は macOS のバージョンによって変わることがあるため、可能ならば変化の少ないそれらの商用フォントを利用したほうが妥当です。

`kanji-config-updmap-sys` コマンドの `status` オプションで利用可能か調べられます。

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

- TeX Wiki の記事[ヒラギノフォント](https://texwiki.texjp.org/?ヒラギノフォント)

### kanij-config-updmap-sys のフォントセット候補
`kanji-config-updmap-sys` コマンドで示されるフォントセット候補をまとめておきます。セットで利用するフォントが見つからない場合は候補には表示されません。`/usr/local/texlive/texmf-local/fonts` 下位フォルダにフォントファイルを入れているはずなのに表示されないときには、`sudo mktexlsr` で TeX のファイル探索データベースを更新し直してみてください。

- `ms-hg`：MS 系フォント + HG フォント
- `ipa-hg`：IPA フォント + HG フォント
- `ipaex-hg`：IPAex フォント + HG フォント
- `moga-mobo`：Moga フォント + Mobo フォント
- `moga-mobo-ex`：MogaEx フォント + MoboEx フォント
- `moga-maruberi`：Moga フォント + モトヤ L マルベリ
- `kozuka-pro`：小塚フォント Pro
- `kozuka-pr6`：小塚フォント Pr6
- `kozuka-pr6n`：小塚フォント Pr6N
- `hiragino-pro`：ヒラギノ6書体 Pro/Std + 明朝 W2
- `hiragino-pron`：ヒラギノ6書体 ProN/StdN + 明朝 W2
- `hiragino-elcapitan-pro`：ヒラギノ（macOS El Capitan版）Pro/Std + 明朝 W2
- `hiragino-elcapitan-pron`：ヒラギノ（macOS El Capitan版）ProN/StdN + 明朝 W2
- `morisawa-pro`：モリサワ7書体 Pro
- `morisawa-pr6n`：モリサワ7書体 Pr6N
- `yu-win`：遊書体（Windows 8 版）
- `yu-win10`：遊書体（Windows 10 版）
- `yu-osx`：遊書体（macOS 版）

## フォントの設定（Linux＋商用フォント）

cjk-gs-integrate-macos はありませんが、Linux でもおおむね macOS と考え方は同じです。

macOS の手順と同じように TLContrib から japanese-otf-nonfree および japanese-otf-uptex-nonfree パッケージをインストールします。

```
$ sudo tlmgr repository add http://contrib.texlive.info/current tlcontrib
$ sudo tlmgr pinning add tlcontrib '*'
$ sudo tlmgr install japanese-otf-nonfree japanese-otf-uptex-nonfree
```

購入済みあるいは購読している小塚やモリサワ・ヒラギノのフォントを、`/usr/share/fonts` または `/usr/local/share/fonts` に入れておきます。サブフォルダを作成してもかまいません。

次に、`cjk-gs-integrate` でリンクを作成します。このツールの挙動としては、`/usr/local/texlive/TeX Liveバージョン/texmf-dist/fonts/misc/cjk-gs-integrate` フォルダにある dat ファイルに定義されているフォント名と合致した場合には、シンボリックリンクが作られます。うまく作られないときには、dat ファイルと照合して、元ファイルのファイル名が正しいかを確認しましょう。

```
$ OSFONTDIR=/usr/local/share/fonts// sudo -E cjk-gs-integrate --link-texmf
```

ここでは環境変数 OSFONTDIR で `/usr/local/share/fonts` を追加探索パスとしています（`//` は下位サブフォルダもすべて探索するという意味です）。また、環境変数を尊重するよう `sudo` コマンドには `-E` オプションを付けました。

実行が済んだら、リンクしたファイルを TeX のプログラムから見つけられるよう、ファイルデータベースを更新します。

```
$ sudo mktexlsr
```

`kanji-config-updmap-sys` コマンドでマップを設定します。

```
$ sudo kanji-config-updmap-sys status （利用可能なマップを一覧）
$ sudo kanji-config-updmap-sys --jis2004 morisawa-pr6n （JIS2004のモリサワフォント）
```

- ★/usr/local/share/fontsがfontconfigに設定されているのはDebian系だけだろうか。RH系でもそうならcjk-gs-integrate自体で/usr/local/share/fontsをデフォルトで探索に加えてくれるよう要望すべきか？

## フォントの設定（Linux＋Noto フォント）

Google とAdobe が作成した [Noto CJK フォント](https://www.google.com/get/noto/) は、オープンソースライセンスの高品質なフォントです。Google では Noto Serif CJK・Noto Sans CJKという名前、Adobe では源ノ明朝・源ノ角ゴシックという名前で配布されていますが、実体としては同じです。

Noto CJK にはその名前のとおり中国語・日本語・韓国語の字形が含まれますが、ここではひとまず日本語のみに絞って設定する方法を紹介しておきます。まず、Serif（明朝体）と Sans（ゴシック体）の2つのフォントをダウンロードします。

- [Noto Serif CJK JP](https://www.google.com/get/noto/#serif-jpan)
- [Noto Sans CJK JP](https://www.google.com/get/noto/#sans-jpan)

`/usr/local/texlive/texmf/fonts/opentype` に適当にフォルダを作って、ダウンロードした zip ファイルを展開します（OS で利用できるように別フォルダに置いた場合には、そこからシンボリックリンクを張ります）。たとえば次のようになります。

```
.
├── noto-sanscjk
│   ├── LICENSE_OFL.txt
│   ├── NotoSansCJKjp-Black.otf
│   ├── NotoSansCJKjp-Bold.otf
│   ├── NotoSansCJKjp-DemiLight.otf
│   ├── NotoSansCJKjp-Light.otf
│   ├── NotoSansCJKjp-Medium.otf
│   ├── NotoSansCJKjp-Regular.otf
│   ├── NotoSansCJKjp-Thin.otf
│   ├── NotoSansMonoCJKjp-Bold.otf
│   ├── NotoSansMonoCJKjp-Regular.otf
│   └── README
└── noto-serifcjk
    ├── LICENSE_OFL.txt
    ├── NotoSerifCJKjp-Black.otf
    ├── NotoSerifCJKjp-Bold.otf
    ├── NotoSerifCJKjp-ExtraLight.otf
    ├── NotoSerifCJKjp-Light.otf
    ├── NotoSerifCJKjp-Medium.otf
    ├── NotoSerifCJKjp-Regular.otf
    ├── NotoSerifCJKjp-SemiBold.otf
    └── README
```

TeX のファイルデータベースを更新するために `mktexlsr` コマンドを実行します。

```
$ sudo mktexlsr
```

Noto フォントは `kanji-config-updmap-sys` の選択肢にはないので、[使用書体の変更（upLaTeX 編）](uptex-fonts.html) にあるとおり pxchfon パッケージを使います。Re:VIEW のプロジェクトの `sty/review-custom.sty` に次のように追加します。

```
\usepackage[noto]{pxchfon}
```

JIS2004 字形にする場合は、`config.yml` の texdocumentclass パラメータに jis2004 オプションを追加します。

```
texdocumentclass: ["review-jsbook", "media=print,paper=a5"]
  ↓
texdocumentclass: ["review-jsbook", "media=print,paper=a5,jis2004"]
```

![JIS2004 字形の Noto フォント表示](images/noto.png)

- [upLaTeX文書で源ノ明朝／Noto Serif CJKを簡単に使う方法](https://qiita.com/zr_tex8r/items/9dfeafecca2d091abd02)
- otc 形式フォントを使いたいときには `noto-otc` を指定する。
- Debian GNU/Linux Stretch の場合、pxchfon パッケージが古く noto マップはそもそも収録されていない。

## TeX Live のインストール（Windows）

ここでは Windows 10 へ TeX Live をインストールする方法を説明します。

[サイト](https://www.tug.org/texlive/acquire-netinstall.html)から `install-tl-windows.exe` をダウンロードし、実行します。

（こちらも、このあとの工程でパッケージのダウンロードおよび検証に失敗するようであれば、ダウンロード先を明示してみると解決するかもしれません。たとえば JAST ミラーであれば、コマンドプロンプトを開き、`cd` コマンドでダウンロードしたフォルダに移動した上で、`install-tl-windows --repository http://ftp.jaist.ac.jp/pub/CTAN/systems/texlive/tlnet/` と指定します。）

「不明な発行元」の警告が表示されることがありますが、仕方がないので継続して実行しましょう。

ミニインストーラが起動します。

![TeX Live ミニインストーラの起動](images/tl-win1.png)

デフォルトでは「Simple install (big)」が選ばれていますが、「Custom install」にチェックして「Next>」ボタンをクリックします。次に「Install」をクリックして先に進みます。しばらく待つと本番の GUI インストーラが起動します。

![TeX Live インストーラ画面と警告](images/tl-win2.png)

管理者権限を与えていないために現在のユーザー用にしか導入できない警告が表示されますが、通常は現在のユーザーが使えれば問題ないでしょう。「続行」をクリックします。

いろいろなメニューがありますが、基本的には先の Linux・macOS と設定する項目は変わりません。

- スキーム：「最小限スキーム」を選択
- 導入コレクション：「TeX外部プログラム」「推奨されるフォント」「日本語」「LaTeX追加パッケージ」を選択（「不可欠なプログラムとファイル」「Windows限定サポートプログラム」はデフォルトで選択済み）。「追加フォント」「LuaTeXパッケージ」は必要に応じて
- fontとmacroのdocツリーを導入：不要なら「いいえ」
- fontとmacroのソースツリーを導入：不要なら「いいえ」

![TeX Live インストーラでの設定](images/tl-win3.png)

選択し終えたら、「TeX Liveの導入」をクリックします。インストールが完了すると、`C:\texlive\2018` に TeX Live が構築されます。インストーラメニューで記載があったように、パスは設定済みなので、すぐに利用できます。

日本語フォントセットの変更は、Linux・macOS と同様に `kanji-config-updmap-sys` を使えます。

![日本語フォントセットの変更](images/tl-win4.png)

`ms` は MS 明朝・ゴシック、`yu-win10` は Windows 10 バンドルの遊書体です。ただし、バンドル版の遊書体はそれを埋め込みで利用した場合の頒布行動に対して可とも不可とも明示されておらず、極めて曖昧な状態に置かれています。

新しいコマンドプロンプトを開き、Re:VIEW プロジェクトをビルドできることを確認します。
![MS 明朝・ゴシック埋め込みでのプレビュー](images/tl-win5.png)

モリサワなどのフォントがインストールされている場合は TLContrib から前掲の手順でセットアップします。

```
> tlmgr repository add http://contrib.texlive.info/current tlcontrib
> tlmgr pinning add tlcontrib '*'
> tlmgr install japanese-otf-nonfree japanese-otf-uptex-nonfree
> cjk-gs-integrate --link-texmf
> mktexlsr
> kanji-config-updmap-sys status
> kanji-config-updmap-sys --jis2004 マップ名
```

Noto フォントの利用は「フォントの設定（Linux＋Noto フォント）」に同じです。texmf-local のパスはデフォルトのインストールでは `C:\texlive\texmf-local` なので読み替えて実行します。

- Windows 向けにはいわゆる角藤版 TeX と呼ばれる [W32TeX](http://w32tex.org/index-ja.html) も広く使われていますが、ここでは説明の統一のために TeX Live を使うことにしました。
- Ghostscriptは必要?(epsは使わない前提で)
- tlmgr pinningでwarningが出るのはOK?
- cjk-gs-integrate は only partial support for Windows! だがどこの部分がパーシャル?
- Windowsの場合、cjk-gs-integrateはgsなしでも動く模様。ただしすごく時間がかかる?
