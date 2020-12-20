# -*- coding: utf-8 -*-
# リストをpygments + mintedでハイライトする
# Copyright 2020 Kenshi Muto
module ReVIEW
  module CompilerOverride
    def non_escaped_commands
      if @builder.highlight?
        # デフォルトは %i[list emlist listnum emlistnum cmd]
        # cmdをハイライトから除外してみる
        %i[list emlist listnum emlistnum]
      else
        []
      end
    end
  end

  class Compiler
    prepend CompilerOverride
  end

  module LATEXBuilderOverride
    def builder_init_file
      super
      @predefined_mint_style = %w[python ruby]
    end

    def cmd(lines, caption = nil, lang = nil)
      # cmdについてはハイライトなし版のみを使う
      blank
      common_code_block(nil, lines, 'reviewcmd', caption, lang) { |line, idx| code_line('cmd', line, idx, nil, caption, lang) }
    end

    # リスト環境をcommon_minted_codeに任せる。言語のデフォルトにshを設定しておく
    def emlist(lines, caption = nil, lang = 'sh')
      common_minted_code(nil, 'emlist', nil, lines, caption, lang)
    end

    def emlistnum(lines, caption = nil, lang = 'sh')
      common_minted_code(nil, 'emlist', line_num, lines, caption, lang)
    end

    def list(lines, id, caption, lang = 'sh')
      common_minted_code(id, 'list', nil, lines, caption, lang)
    end

    def listnum(lines, id, caption, lang = 'sh')
      common_minted_code(id, 'list', line_num, lines, caption, lang)
    end

    def common_minted_code(id, command, lineno, lines, caption, lang)
      blank
      puts '\\begin{reviewlistblock}'
      if caption.present?
        if command =~ /emlist/ || command =~ /cmd/ || command =~ /source/
          captionstr = macro('review' + command + 'caption', compile_inline(caption))
        else
          begin
            if get_chap.nil?
              captionstr = macro('reviewlistcaption', "#{I18n.t('list')}#{I18n.t('format_number_header_without_chapter', [@chapter.list(id).number])}#{I18n.t('caption_prefix')}#{compile_inline(caption)}")
            else
              captionstr = macro('reviewlistcaption', "#{I18n.t('list')}#{I18n.t('format_number_header', [get_chap, @chapter.list(id).number])}#{I18n.t('caption_prefix')}#{compile_inline(caption)}")
            end
          rescue KeyError
            error "no such list: #{id}"
          end
        end
      end
      @doc_status[:caption] = nil

      if caption_top?('list') && captionstr
        puts captionstr
      end

      body = lines.inject('') { |i, j| i + detab(j) + "\n" }
      args = ''
      if lineno
        args = "linenos=true,firstnumber=#{lineno}"
      end
      if @predefined_mint_style.include?(lang)
        # 事前定義ありの場合は 「言語code」環境を利用
        puts %Q(\\begin{#{lang}code*}{#{args}})
        print body
        puts %Q(\\end{#{lang}code*})
      else
        # 事前定義なしの場合のデフォルト表現
        args += ',' if args
        args += 'breaklines=true,breakanywhere=true,frame=lines'
        puts %Q(\\begin{minted}[#{args}]{#{lang}})
        print body
        puts %Q(\\end{minted})
      end

      if !caption_top?('list') && captionstr
        puts captionstr
      end

      puts '\\end{reviewlistblock}'
      blank
    end
  end

  class LATEXBuilder
    prepend LATEXBuilderOverride
  end
end
