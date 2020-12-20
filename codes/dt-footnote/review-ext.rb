# -*- coding: utf-8 -*-
# 説明箇条書き (:) の見出しに脚注を入れたときの対処
# Copyright 2020 Kenshi Muto
module ReVIEW
  module CompilerOverride
    def compile_dlist(f)
      @strategy.dl_begin
      while /\A\s*:/ =~ f.peek
        if @strategy.class.to_s =~ /LATEX/
          s = f.gets
          @strategy.dt(s.sub(/\A\s*:/, '').strip)
        else
          @strategy.dt(text(f.gets.sub(/\A\s*:/, '').strip))
        end
        desc = f.break(/\A(\S|\s*:|\s+\d+\.\s|\s+\*\s)/).map { |line| text(line.strip) }
        @strategy.dd(desc)
        f.skip_blank_lines
        f.skip_comment_lines
      end
      @strategy.dl_end
    end
  end

  class Compiler
    prepend CompilerOverride
  end

  module LATEXBuilderOverride
    def dt(str)
      str.sub!(/\[/) { '\lbrack{}' }
      str.sub!(/\]/) { '\rbrack{}' }
      @doc_status[:caption] = true
      puts '\item[' + compile_inline(str) + '] \mbox{} \\\\'
      @doc_status[:caption] = nil
    end
  end

  class LATEXBuilder
    prepend LATEXBuilderOverride
  end
end
