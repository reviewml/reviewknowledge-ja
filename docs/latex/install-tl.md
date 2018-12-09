2018/12/6 by @kmuto

# Re:VIEW 向け日本語 TeXLive 環境のセットアップ（Unix、macOS）

OS のパッケージに頼らず、TeXLive の最新版をインストールする方法を説明します。

----

[TeXLive](https://www.tug.org/texlive/) は、TeX とそれにまつわる環境一式を提供する巨大な集合体です。

インストールに必要な作業自体はそう難しくはないのですが、デフォルトでは「すべて」をインストールしようとするために膨大な容量と時間を消費するほか、ネットワークからのダウンロードではエラーで失敗することも多々あります。日本語で Re:VIEW を利用する上では使わないファイルも大量です。

ここでは「Re:VIEW の PDF 変換が通りさえすればよい」という割り切りのもとで TeXLive のセットアップ手順を紹介します。

- 執筆時点の TeXLive 2018 に基づいています。
- テスト環境の都合で、Linux および macOS のみの説明としています。★Windows についてもいずれ書き足したいところです。
- TeX コンパイラには upLaTeX を利用することを前提とします。特にフォントの設定については LuaLaTeX のほうがシステムフォントの探索などでのトラブルが少ないのですが、現状の Re:VIEW の基本設定は upLaTeX コンパイラ寄りになっています。
- Debian GNU/Linux、Ubuntu Linux で OS のパッケージを利用して最小構成を構築したい場合は、[Re:VIEW image for Docker](https://hub.docker.com/r/vvakame/review/) の Dockerfile の内容が参考になるでしょう。

## TeXLive のインストール
TeXLive のインストーラは `install-tl` という名前のファイルです。Linux・macOS いずれでも、[サイト](https://www.tug.org/texlive/acquire-netinstall.html)から「install-tl-unx.tar.gz」をダウンロードします。

ここではホームの `Download` フォルダにダウンロードしたとします。ターミナルを開いて以下のように tar.gz アーカイブファイルを展開し、そのフォルダに移動します。

```
$ cd ~/Download
$ tar xvf install-tl-unx.tar.gz
install-tl-20181205/...
 ...
$ cd install-tl-*
```

次に、この中の `install-tl` を root 権限で実行します。このとき、ダウンロードリポジトリを指定できます。デフォルトのままだと CDN のミラーサイトになるのですが、TeXLive のミラーサイトの品質はバラバラで、速度が出なかったり、はたまたミラーがちゃんとできていなかったりなどの余計な問題にひっかかることが多いため、最も安定していて速度も出る JAIST を選んでいます。

```
$ sudo ./install-tl --repository http://ftp.jaist.ac.jp/pub/CTAN/systems/texlive/tlnet/
```

17.58.03.png

テキストベースのインストーラの画面が開きます。デフォルトではスキームに scheme-full が選択されていて、すべてのパッケージファイルがインストールされてしまう（5.6GB にもなる）ので、まずはこれを変更します。

メニューにあるとおり `S` と入れて Enter キーを押します。

17.58.12.png

スキームの選択になります。TeX のスタイルなど個々の機能や拡張はパッケージとして配布されています。TeXLive ではこのパッケージを言語あるいは TeX コンパイラなどの目的単位にグループ化し、コレクションと呼んでいます。さらにこのコレクションを、依存関係も考慮してユーザー向けにもう少しわかりやすい選択肢としてまとめたものがスキームです。

ここではスキームを最小のものにするために「e. minimal scheme」を選ぶことにします。`e`、Enter キーと押します。これで e 行が `[X]` となるので、`R`、Enter キーと押してメニューに戻ります。

メインメニューから今度はコレクションを選ぶため、`C`、Enter キーと押します。

コレクションの一覧が表示されます。スキームを最小にしたので、「a. Essential programs and files」だけに `[X]` とチェックが付いている状態です。Re:VIEW で日本語利用を使う範囲で見回して、以下を使うことにします。「fundamental」のように外すとまずいのでは？ と怖くなるかもしれませんが、依存関係でこれらは自動で選ばれるので問題ありません。

- c. TeX auxiliary programs
- f. Recommended fonts
- x. Japanese （依存関係で m. Chinese/Japanese/Korean (base) も入る）
- E. LaTeX additional packages （依存関係で F. LaTeX recommended packages、D. LaTeX fundamental packages も入る）

これらにチェックを付けるため「`cfxE`」とまとめて記入し、Enter キーを押します。

22.40.03.png

- コレクションの選定は、@munepixyz さんが作られている[最小プロファイル](https://gist.github.com/munepi/cb7999cb0f4d0c8629d1593fe3117e33)を参考にしました。
- XeTeX パッケージは過去 `dvipdfmx` コマンドの実行に必要でしたが、整理されて dvipdfmx パッケージが基本コレクションに収録されるようになったので、XeTeX を使うのでなければ選択する必要はなくなっているようです。

必要であればほかに以下を加えるのもよいでしょう。

- e. Additional fonts：いろいろな欧文フォントを利用したい場合
- G. LuaTeX packages: LuaTeX を使いたい場合

`R`、Enter キーと押してメインメニューに戻ります。

次はオプションを設定します。`O`、Enter キーでオプションメニューに移動します。

22l.40.42

以下の2つのオプションは TeX のドキュメントやソースコードのインストール設定ですが、Re:VIEW から TeX を利用するだけであれば使うことがないでしょう（レイアウトをいろいろ変更したいというときには、これらのオプションはそのままにしておくべきです！ `texdoc` コマンドを使って TeX のドキュメントを参照できます。ネットのつまみ食いはお腹を壊します）。

- D. install font/macro doc tree
- S. install font/macro source tree

`D`、Enter キー、`S`、Enter キーでチェックを外し、`R`、Enter キーでメインメニューに戻ります。

これで Re:VIEW を動かすに足る最小構成ができました。`I`、Enter キーでダウンロードとインストールを実行します。

22.42.13

ブロードバンドであれば、20〜30分ほどでダウンロードとセットアップが完了します。

18.21.31

最後のメッセージにあるとおり、プログラムは `/usr/local/texlive/<TeXLiveバージョン>/bin/<アーキテクチャ名>` フォルダに用意されるので、ここにパスを通す必要があります。たとえば次のようにホームフォルダの `.bashrc` に追加します（これはパスの先頭に TeXLive へのパスを通します）。

```
$ echo "PATH=/usr/local/texlive/2018/bin/x86_64-darwin:$PATH" >> ~/.bashrc （macOSの場合）
$ echo "PATH=/usr/local/texlive/2018/bin/x86_64-linux:$PATH" >> ~/.bashrc （Linuxの場合）
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

## Ghostscript

以降のフォントの自動設定をしたかったり、あるいはドキュメント内で eps 形式のファイルを使いかったりするときには、TeXLive とは別に、Postscript インタプリタの Ghostscript が必要です。

Debian GNU/Linux や Ubuntu Linux の場合は deb パッケージをインストールします。

```
$ sudo apt-get install ghostscript
```

macOS の場合は [Homebrew](https://brew.sh/index_ja) を導入した上でインストールするのがよいでしょう。

```
$ brew install ghostscript
```

- Ghostscriptなしでフォント自動設定機能だけを使う方法（Re: MacのTexliveインストールの際のシンボリックリンクの貼り直しがうまくいかない）: [https://oku.edu.mie-u.ac.jp/tex/mod/forum/discuss.php?d=2229#p13069](https://oku.edu.mie-u.ac.jp/tex/mod/forum/discuss.php?d=2229#p13069)

## パッケージの追加と TeXLive の更新
後からパッケージが必要になったり、あるいは不要になったので削除したかったりといったときの TeXLive のパッケージ管理は `tlmgr` コマンドで行います。

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

Linux で `sudo` コマンドを使う場合、secure_path 設定に TeXLive のパスを追加する必要があるかもしれません。`visudo` コマンドで以下のようにパスを加えておきましょう。

```
Defaults  secure_path="/usr/local/texlive/2018/bin/x86_64-linux:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
```

## フォントの設定（macOS）

生成される PDF の日本語フォント（リュウミンや中ゴシックなど）の代替書体には、デフォルトで IPA フォントが割り当てられています。macOS のシステムにデフォルトでインストールされているヒラギノフォントを利用するには、もう少し設定が必要です。

これには cjk-gs-integrate-macos というパッケージが便利です。外部の商業フォントファイルを使用する cjk-gs-integrate-macos のようなパッケージは、TeXLive の主リポジトリとは分離された TLContrib というリポジトリに置かれています。

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

そして、macOS のシステムのフォントファイルを TeXLive から利用できるようにリンクします（`-macos` と付くことに注意してください）。

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

- TeX Wiki の記事[TLContrib](https://texwiki.texjp.org/?TLContrib)
- [cjk-gs〜のMojave対応](https://twitter.com/aminophen/status/1054735620776570881)

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

次に、`cjk-gs-integrate` でリンクを作成します。このツールの挙動としては、`/usr/local/texlive/TeXLiveバージョン/texmf-dist/fonts/misc/cjk-gs-integrate` フォルダにある dat ファイルに定義されているフォント名と合致した場合には、シンボリックリンクが作られます。うまく作られないときには、dat ファイルと照合して、元ファイルのファイル名が正しいかを確認しましょう。

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
sudo kanji-config-updmap-sys status （利用可能なマップを一覧）
sudo kanji-config-updmap-sys --jis2004 morisawa-pr6n （JIS2004のモリサワフォント）
```

- ★/usr/local/share/fontsがfontconfigに設定されているのはDebian系だけだろうか。RH系でもそうならcjk-gs-integrate自体で/usr/local/share/fontsをデフォルトで探索に加えてくれるよう要望すべきか？

## フォントの設定（Linux＋Noto フォント）

★Notoの説明はまだ変則的手段が必要? (kanji-config-updmap-sysの対象にない)


