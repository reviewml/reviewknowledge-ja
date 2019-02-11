# いささか無茶なハイライトエスケープ回避 (EPUBMaker/WebMaker専用)
# Copyright (c) 2019 Kenshi Muto
module ReVIEW
  module CompilerOverride
    def read_command(f)
      line = f.gets
      name = line.slice(/[a-z]+/).to_sym
      ignore_inline = (name == :embed)

      if @strategy.class == HTMLBuilder
        # HTMLBuilder固有でリスト環境のinline処理を遅延
        if %i[embed list emlist source cmd listnum emlistnum].include?(name)
          ignore_inline = true
        end
      end

      args = parse_args(line.sub(%r{\A//[a-z]+}, '').rstrip.chomp('{'), name)
      @strategy.doc_status[name] = true
      lines = block_open?(line) ? read_block(f, ignore_inline) : nil
      @strategy.doc_status[name] = nil
      [name, args, lines]
    end

    def text(str, esc_array = nil)
      return '' if str.empty?
      words = replace_fence(str).split(/(@<\w+>\{(?:[^\}\\]|\\.)*?\})/, -1)
      words.each do |w|
        if w.scan(/@<\w+>/).size > 1 && !/\A@<raw>/.match(w)
          error "`@<xxx>' seen but is not valid inline op: #{w}"
        end
      end
      result = @strategy.nofunc_text(revert_replace_fence(words.shift))
      until words.empty?
        if esc_array # esc_array指定があれば退避
          esc_array << compile_inline(revert_replace_fence(words.shift.gsub(/\\\}/, '}').gsub(/\\\\/, '\\')))
          result << "\x01"
        else
          result << compile_inline(revert_replace_fence(words.shift.gsub(/\\\}/, '}').gsub(/\\\\/, '\\')))
        end
        result << @strategy.nofunc_text(revert_replace_fence(words.shift))
      end
      result
    rescue => err
      error err.message
    end
  end

  class Compiler
    prepend CompilerOverride
  end

  module HTMLBuilderOverride
    def compile_inline(s, esc_array = nil)
      @compiler.text(s, esc_array)
    end

    def revert_escape(s, esc_array)
      s.gsub("<span class=\"err\">\x01</span>", "\x01").
        gsub("<span style=\"border: 1px solid #FF0000\">\x01</span>", "\x01").
        gsub("\x01") { esc_array.shift }
    end

    def list_body(_id, lines, lang)
      class_names = ['list']
      lexer = lang
      class_names.push("language-#{lexer}") unless lexer.blank?
      class_names.push('highlight') if highlight?
      print %Q(<pre class="#{class_names.join(' ')}">)
      esc_array = []
      lines.map! { |l| compile_inline(l, esc_array) }
      body = lines.inject('') { |i, j| i + detab(j) }
      puts revert_escape(highlight(body: body, lexer: lexer, format: 'html'), esc_array)
      puts '</pre>'
    end

    def source_body(_id, lines, lang)
      print %Q(<pre class="source">)
      esc_array = []
      lines.map! { |l| compile_inline(l, esc_array) }
      body = lines.inject('') { |i, j| i + detab(j) }
      lexer = lang
      puts revert_escape(highlight(body: body, lexer: lexer, format: 'html'), esc_array)
      puts '</pre>'
    end

    def listnum_body(lines, lang)
      esc_array = []
      lines.map! { |l| compile_inline(l, esc_array) }
      body = lines.inject('') { |i, j| i + detab(j) }
      lexer = lang
      first_line_number = line_num
      hs = highlight(body: body, lexer: lexer, format: 'html', linenum: true,
                     options: { linenostart: first_line_number })

      if highlight?
        puts revert_escape(hs, esc_array)
      else
        class_names = ['list']
        class_names.push("language-#{lang}") unless lang.blank?
        print %Q(<pre class="#{class_names.join(' ')}">)
        revert_escape(hs, esc_array).split("\n").each_with_index do |line, i|
          puts detab((i + first_line_number).to_s.rjust(2) + ': ' + line)
        end
        puts '</pre>'
      end
    end

    def emlist(lines, caption = nil, lang = nil)
      puts %Q(<div class="emlist-code">)
      if caption.present?
        puts %Q(<p class="caption">#{compile_inline(caption)}</p>)
      end
      class_names = ['emlist']
      class_names.push("language-#{lang}") unless lang.blank?
      class_names.push('highlight') if highlight?
      print %Q(<pre class="#{class_names.join(' ')}">)
      esc_array = []
      lines.map! { |l| compile_inline(l, esc_array) }
      body = lines.inject('') { |i, j| i + detab(j) }
      lexer = lang
      puts revert_escape(highlight(body: body, lexer: lexer, format: 'html'), esc_array)
      puts '</pre>'
      puts '</div>'
    end

    def emlistnum(lines, caption = nil, lang = nil)
      puts %Q(<div class="emlistnum-code">)
      if caption.present?
        puts %Q(<p class="caption">#{compile_inline(caption)}</p>)
      end

      esc_array = []
      lines.map! { |l| compile_inline(l, esc_array) }
      body = lines.inject('') { |i, j| i + detab(j) }
      lexer = lang
      first_line_number = line_num
      hs = highlight(body: body, lexer: lexer, format: 'html', linenum: true,
                     options: { linenostart: first_line_number })
      if highlight?
        puts revert_escape(hs, esc_array)
      else
        class_names = ['emlist']
        class_names.push("language-#{lang}") unless lang.blank?
        class_names.push('highlight') if highlight?
        print %Q(<pre class="#{class_names.join(' ')}">)
        revert_escape(hs, esc_array).split("\n").each_with_index do |line, i|
          puts detab((i + first_line_number).to_s.rjust(2) + ': ' + line)
        end
        puts '</pre>'
      end

      puts '</div>'
    end

    def cmd(lines, caption = nil)
      puts %Q(<div class="cmd-code">)
      if caption.present?
        puts %Q(<p class="caption">#{compile_inline(caption)}</p>)
      end
      print %Q(<pre class="cmd">)
      esc_array = []
      lines.map! { |l| compile_inline(l, esc_array) }
      body = lines.inject('') { |i, j| i + detab(j) }
      lexer = 'shell-session'
      puts revert_escape(highlight(body: body, lexer: lexer, format: 'html'), esc_array)
      puts '</pre>'
      puts '</div>'
    end

    def highlight(ops)
      if @book.config['pygments'].present?
        raise ReVIEW::ConfigError, %Q('pygments:' in config.yml is obsoleted.)
      end
      if !highlight? || !ops[:lexer].present? # lexer指定がなければハイライトしない
        return ops[:body].to_s
      end

      if @book.config['highlight']['html'] == 'pygments'
        highlight_pygments(ops)
      elsif @book.config['highlight']['html'] == 'rouge'
        highlight_rouge(ops)
      else
        raise ReVIEW::ConfigError, "unknown highlight method #{@book.config['highlight']['html']} in config.yml."
      end
    end
  end

  class HTMLBuilder
    prepend HTMLBuilderOverride
  end
end
