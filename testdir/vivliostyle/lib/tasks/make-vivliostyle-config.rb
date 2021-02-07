#!/usr/bin/env ruby
# Copyright (c) 2021 Kenshi Muto
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
require 'fileutils'
require 'zip'
require 'rexml/document'
require 'open3'

def extract_epub(epubfile, exportdir)
  opf = nil
  zf = Zip::File.new(epubfile)
  zf.each_with_index do |entry, index|
    if entry.size > 0
      dirname = File.dirname(entry.name)
      unless File.exist?(File.join(exportdir, dirname))
        FileUtils.mkdir_p(File.join(exportdir, dirname))
      end
      File.write(File.join(exportdir, entry.name), zf.get_input_stream(entry).read)
      if entry.name =~ /\.opf$/
        opf = entry.name
      end
    end
  end
  opf
end

def dump_vsconfig(opf, execdir)
  # Parse OPF
  doc = REXML::Document.new(File.read(File.join(execdir, opf)))
  entries = []

  doc.each_element('/package/spine/itemref') do |e|
    entries.push(e.attributes['idref'])
  end

  doc.each_element('/package/manifest/item[@media-type="application/xhtml+xml"]') do |e|
    i = entries.index(e.attributes['id'])
    if i
      entries[i] = e.attributes['href']
    end
  end

  title = 'BOOK'
  doc.each_element('/package/metadata/dc:title') do |e|
    title = e.texts.join
  end

  authors = []
  doc.each_element('/package/metadata/dc:creator') do |e|
    authors.push(e.texts.join)
  end

  lang = 'en'
  doc.each_element('/package/metadata/dc:language') do |e|
    lang = e.texts.join
  end

  # Dump vivliostyle.config.js
  ret = <<EOT
module.exports = {
  title: '#{title}',
  author: '#{authors.join(", ")}',
  language: '#{lang}',
  // size: 'A4',
  entry: [
EOT

  entries.each do |ent|
    ret << <<EOT
    '#{File.dirname(opf)}/#{ent}',
EOT
  end

  ret << <<EOT
  ],
  output: [
    '#{entries[0].sub(/\..+?$/, '.pdf')}'
  ],
};
EOT

  ret
end

def call_vivliostyle(execdir, exportdir, vsprogram: 'vivliostyle', preview: nil, nosandbox: true)
  Dir.chdir(execdir) do
    args = [ vsprogram,
             preview ? 'preview' : 'build'
           ]
    if nosandbox
      args.push('--no-sandbox')
    end

    begin
      out, status = Open3.capture2e(*args)
    rescue Exception => e
      STDERR.puts "Execution error: #{e}"
      exit 1
    end

    pdf = nil
    Dir.glob('*.pdf').each do |fname|
      pdf = true
      FileUtils.cp(fname, exportdir)
    end

    unless pdf
      STDERR.puts "Something wrong: #{out}"
      exit 1
    end
  end
end

Dir.mktmpdir do |tmpdir|
  opf = extract_epub(ARGV[0], tmpdir)
  File.write(File.join(tmpdir, 'vivliostyle.config.js'), dump_vsconfig(opf, tmpdir))
  vsprogram = ENV['REVIEW_VSBIN'] || 'vivliostyle'
  preview = nil
  if ARGV[1] == 'preview'
    preview = true
  end
  nosandbox = true
  if ENV['REVIEW_VSBIN_USESANDBOX']
    nosandbox = nil
  end
  call_vivliostyle(tmpdir, Dir.pwd, vsprogram: vsprogram, preview: preview, nosandbox: nosandbox)
end
