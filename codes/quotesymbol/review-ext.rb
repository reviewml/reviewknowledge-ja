# -*- coding: utf-8 -*-
# 出力前に “ ” のクォートをバックエンド向きの形に置換する
# Copyright 2020 Kenshi Muto
module ReVIEW
  module LATEXBuilderOverride
    def result
      super.gsub('“', '``').gsub('”', "''")
    end
  end

  class LATEXBuilder
    prepend LATEXBuilderOverride
  end
end
