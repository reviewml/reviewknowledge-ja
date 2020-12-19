# 出力前に “ ” のクォートをバックエンド向きの形に置換する
module ReVIEW
  module HTMLBuilderOverride
    def result
      super.gsub('“', '"').gsub('”', '"')
    end
  end

  class HTMLBuilder
    prepend HTMLBuilderOverride
  end

  module LATEXBuilderOverride
    def result
      super.gsub('“', '``').gsub('”', "''")
    end
  end

  class LATEXBuilder
    prepend LATEXBuilderOverride
  end
end
