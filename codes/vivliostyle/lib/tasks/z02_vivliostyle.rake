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

REVIEW_VSBIN = ENV['REVIEW_VSBIN'] || 'vivliostyle'
REVIEW_VSBIN_USESANDBOX = ENV['REVIEW_VSBIN_USESANDBOX'] ? '' : '--no-sandbox'
REVIEW_VSBIN_OPTIONS = ENV['REVIEW_VSBIN_OPTIONS'] || ''

desc 'run vivliostyle'
task 'vivliostyle:preview': BOOK_EPUB do
  sh "#{REVIEW_VSBIN} preview #{REVIEW_VSBIN_USESANDBOX} #{REVIEW_VSBIN_OPTIONS} #{BOOK_EPUB}"
end

task 'vivliostyle:build': BOOK_EPUB do
  sh "#{REVIEW_VSBIN} build #{REVIEW_VSBIN_USESANDBOX} #{REVIEW_VSBIN_OPTIONS} #{BOOK_EPUB}"
end

task vivliostyle: 'vivliostyle:build'
