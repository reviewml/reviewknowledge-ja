= mintedによるコードハイライト

//cmd[コマンドラインはエスケープなしで普通にRe:VIEWタグ利用]{
> @<b>{ls デスクトップ/test}
file1  file2  {}_  @<chap>{minted}
//}

//embed[latex]{
%\clearpage
//}

//emlist[Pythonのハイライトコード(GitHubフレーバー)][python]{
def f(x):
  y = x ** 2
  return y
//}

//firstlinenum[3]
//emlistnum[行番号付きのハイライトコード][python]{
def f(x):
  y = x ** 2
  return y
//}

//emlist[][ruby]{
#!/usr/bin/env ruby
class MegaGreeter
  attr_accessor :names

  # オブジェクトを作成
  def initialize(names = "World")
    @names = names
  end

  # みんなに挨拶
  def say_hi
    if @names.nil?
      puts "..."
    elsif @names.respond_to?("each")
      # @namesは何らかのリスト…イテレーションしよう!
      @names.each do |name|
        puts "Hello #{name}!"
      end
    else
      puts "Hello #{@names}!"
    end
  end

  # みんなにさよなら
  def say_bye
    if @names.nil?
      puts "..."
    elsif @names.respond_to?("join")
      # カンマでリスト要素を結合
      puts "Goodbye #{@names.join(", ")}.  Come back soon!"
    else
      puts "Goodbye #{@names}.  Come back soon!"
    end
  end
end
//}

//list[auctexel][auctex.el][elisp]{
;;; auctex.el
;;
;; This can be used for starting up AUCTeX.  The following somewhat
;; strange trick causes tex-site.el to be loaded in a way that can be
;; safely undone using (unload-feature 'tex-site).
;;
(autoload 'TeX-load-hack
  (expand-file-name "tex-site.el" (file-name-directory load-file-name)))
(TeX-load-hack)
//}

//listnum[tssample][TypeScriptのサンプル][ts]{
class Car {
  drive() {
    // hit the gas
  }
}
//}
