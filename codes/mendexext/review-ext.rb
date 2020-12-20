# -*- coding: utf-8 -*-
# mendexのBEGIN,END,SEEを索引内に擬似タグを入れて実現する
# Copyright 2020 Kenshi Muto
module ReVIEW
  module LATEXBuilderOverride
    def index(str)
      post = nil

      if str =~ /◆→BEGIN←◆/
        post = '|('
        str.sub!('◆→BEGIN←◆', '')
      elsif str =~ /◆→END←◆/
        post = '|)'
        str.sub!('◆→END←◆', '')
      elsif str =~ /◆→SEE\((.+?)\)←◆/
        post = "|see{#{escape($1)}}"
        str.sub!(/◆→SEE\((.+?)\)←◆/, '')
      end

      "#{super(str).chop}#{post}}"
    end

    # ALT: あらゆる自己責任になるが、読みとか含めてLaTeXそのままの
    # \index記法で書いてしまうという手もある。フリーダム！
    # \textt{}とかで等幅にしたいとかね。
    # def index(str)
    #   %Q(\\index{#{str}})
    # end
  end

  class LATEXBuilder
    prepend LATEXBuilderOverride
  end
end
