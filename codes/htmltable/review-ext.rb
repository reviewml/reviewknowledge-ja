# -*- coding: utf-8 -*-
# ブラウザで動的にTeX用表画像を作成するための //htmltable, //rawhtmltable
# Copyright 2020 Kenshi Muto
module ReVIEW
  require 'review/htmlbuilder'

  module BuilderOverride
    Compiler.defblock :htmltable, 0..3
    Compiler.defblock :rawhtmltable, 0..3

    def htmltable(lines, id = nil, caption = nil, metrics = nil)
      table(lines, id = nil, caption = nil)
    end

    def rawhtmltable(lines, id = nil, caption = nil, metrics = nil)
      table(lines, id = nil, caption = nil)
    end
  end

  class Builder
    prepend BuilderOverride
  end

  module IndexBuilderOverride
    def htmltable(lines, id = nil, caption = nil, metrics = nil)
      check_id(id)
      if id
        item = ReVIEW::Book::Index::Item.new(id, @table_index.size + 1, caption)
        @table_index.add_item(item)
      end
    end

    def rawhtmltable(lines, id = nil, caption = nil, metrics = nil)
      check_id(id)
      if id
        item = ReVIEW::Book::Index::Item.new(id, @table_index.size + 1, caption)
        @table_index.add_item(item)
      end
    end
  end

  class IndexBuilder
    prepend IndexBuilderOverride
  end

  module CompilerOverride
    def initialize(builder)
      super(builder)
      @non_parsed_commands += %i[rawhtmltable]
    end
  end

  class Compiler
    prepend CompilerOverride
  end

  module HTMLBuilderOverride
    def htmltable(lines, id = nil, caption = nil, metrics = nil)
      if id
        puts %Q(<div id="#{normalize_id(id)}" class="table htmltable">)
      else
        puts %Q(<div class="table htmltable">)
      end
      super(lines, id, caption)
      puts '</div>'
    end

    def rawhtmltable(lines, id = nil, caption = nil, metrics = nil)
      if id
        puts %Q(<div id="#{normalize_id(id)}" class="table rawhtmltable">)
      else
        puts %Q(<div class="table rawhtmltable">)
      end
      puts lines.join("\n")
      puts '</div>'
    end

    def cellattr(str)
      return [str, ''] if str !~ /\A<\?dtp table/
      attr = []
      str.match(/<\?dtp table (.+) \?>/) do |m|
        str = $'
        m[1].split(',').each do |kv|
          k, v = kv.split('=', 2)
          k = 'class' if k == 'cellstyle'
          attr.push(%Q(#{k}="#{v}"))
        end
      end
      return [str, ' ' + attr.join(' ')]
    end

    def th(str)
      return '' unless str.present?

      str, attr = cellattr(str)
      "<th#{attr}>#{str}</th>"
    end

    def td(str)
      return '' unless str.present?

      str, attr = cellattr(str)
      "<td#{attr}>#{str}</td>"
    end
  end

  class HTMLBuilder
    prepend HTMLBuilderOverride
  end

  module LATEXBuilderOverride
    def make_htmlimgtable(type, id)
      @book.config['builder'] = 'html'
      chapterlink = @book.config['chapterlink']
      @book.config['chapterlink'] = nil
      compiler = Compiler.new(HTMLBuilder.new)
      File.write('__REVIEW_HTMLTABLE__.html', compiler.compile(@book.chapter(@chapter.name)))
      @book.config['chapterlink'] = chapterlink
      @book.config['builder'] = 'latex'

      require 'puppeteer'

      unless Dir.exist?(File.join('images', '__htmltable__'))
        Dir.mkdir(File.join('images', '__htmltable__'))
      end

      Puppeteer.launch(headless: true) do |browser|
        page = browser.pages.first || browser.new_page
        page.viewport = Puppeteer::Viewport.new(width: 1400, height: 1200, device_scale_factor: 2)
        page.goto("file://#{Dir.pwd}/__REVIEW_HTMLTABLE__.html##{id}")
        page.focus("div.#{type}##{id} table")
        overlay = page.S("div.#{type}##{id} table")
        overlay.screenshot(path: File.join('images', '__htmltable__', "#{@chapter.name}-#{id}.png"))
      end
    end

    def common_htmltable(type, lines, id, caption, metrics)
      blank
      if caption.present?
        puts "\\begin{table}%%#{id}"
      end

      error "#{type} needs id." unless id

      make_htmlimgtable(type, id)

      begin
        if caption_top?('table') && caption.present?
          table_header(id, caption)
        end
      rescue KeyError
        error "no such table: #{id}"
      end

      puts '\begin{reviewtable}{c}'
      command = 'reviewincludegraphics'

      if metrics.present?
        puts "\\#{command}[#{metrics}]{images/__htmltable__/#{@chapter.name}-#{id}.png}"
      else
        puts "\\#{command}[scale=0.4]{images/__htmltable__/#{@chapter.name}-#{id}.png}"
      end
      puts '\end{reviewtable}'

      if caption.present?
        unless caption_top?('table')
          table_header(id, caption)
        end
        puts '\end{table}'
      end
      blank
    end

    def htmltable(lines, id = nil, caption = nil, metrics = nil)
      common_htmltable('htmltable', lines, id, caption, metrics)
    end

    def rawhtmltable(lines, id = nil, caption = nil, metrics = nil)
      common_htmltable('rawhtmltable', lines, id, caption, metrics)
    end

    def result
      File.unlink('__REVIEW_HTMLTABLE__.html') if File.exist?('__REVIEW_HTMLTABLE__.html')
      super
    end
  end

  class LATEXBuilder
    prepend LATEXBuilderOverride
  end
end
