# PDFをpdftocairoでPNG化後、gimpで白背景を選択透明化
from graphviz import Digraph
import os

G = Digraph(format='pdf')
G.attr(compound='true', fontname='A-OTF UD Shin Maru Go Pr6N', rankdir='LR')

# 外部ツール
G.attr('node', shape='box', fontname='A-OTF UD Shin Maru Go Pr6N')
G.node('vivliocss', 'Vivliostyle.js CSS組版')
G.node('versacss', 'VersaType Converter CSS組版')
G.node('ahcss', 'Antenna House Formatter CSS組版')
G.node('kindlegen', 'kindlegen')
G.node('indesign', 'InDesign')
G.node('latex', 'LaTeX')
G.node('md2review', 'md2review')
G.node('rvbuilder', 'ReVIEW builder')
#G.node('rst', 'review-comple --target=rstbuilder')

# Re:VIEWコマンド類
G.attr('node', shape='box', style='filled', fillcolor='lightblue2')
G.node('init', '作成(review-init)')
G.node('update', '更新(review-update)')
G.node('preproc', 'review-preproc')
G.node('vol', '分量確認(review-vol)')
G.node('epub', 'rake epub (review-epubmaker)')
G.node('web', 'rake web (review-webmaker)')
G.node('idgxml', 'rake idgxml (review-idgxmlmaker)')
G.node('pdf', 'rake pdf (review-pdfmaker)')
G.node('epub2html', 'review-epub2html')
G.node('plaintext', 'rake plaintext (review-textmaker -n)')
G.node('text', 'rake text (review-textmaker)')

# Re:VIEWプロジェクト、ファイル
with G.subgraph(name='cluster_project') as prj:
    prj.attr(style='filled', fillcolor='gold1', margin='30')
    prj.node_attr.update(shape='note', style='filled', fillcolor='cornsilk')
    #prj.node(['rv'])
    prj.edge_attr.update(style='invis')
    prj.edges([('rv', 'rv')])
    prj.attr(label='Re:VIEWプロジェクト')
    #G.attr('node', shape='ellipse', style='filled', fillcolor='gold1')
    #G.node('project', 'Re:VIEWプロジェクト')

# ファイル
G.attr('node', shape='note', style='filled', fillcolor='cornsilk')
G.node('pdffile', 'PDFファイル')
G.node('epubfile', 'EPUBファイル')
G.node('rv', 'Re:VIEWファイル(.re)')
G.node('markdown', 'Markdownファイル')
G.node('sphinx', 'Sphinx rstファイル')

# 展開先
G.attr('node', shape='cds', style='filled', fillcolor='coral')
G.node('handdtp', '出版社や手動DTPへの提出草稿')
G.node('morph', '形態素解析や文体チェック')
G.node('pdfprint', '印刷製本')
G.node('pdfebook', '電子配布')
G.node('amazon', 'Amazon Kindleストア')
G.node('toritugi', '各電子ブックストア')
G.node('website', 'Webサイト')
#G.node('word', 'Microsoft Word')

G.edge('rv', 'epub', ltail='cluster_project')
G.edge('epub', 'epubfile')
G.edge('epubfile', 'epub2html')
G.edge('epub2html', 'vivliocss')
G.edge('epub2html', 'versacss')
G.edge('epub2html', 'ahcss')
#G.edge('epub2html', 'word')
G.edge('vivliocss', 'pdffile')
G.edge('versacss', 'pdffile')
G.edge('ahcss', 'pdffile')
G.edge('epubfile', 'kindlegen')
G.edge('kindlegen', 'amazon')
G.edge('epubfile', 'toritugi')

G.edge('pdffile', 'pdfprint')
G.edge('pdffile', 'pdfebook')

G.edge('rv', 'web', ltail='cluster_project')
G.edge('web', 'website')

G.edge('rv', 'idgxml', ltail='cluster_project')
G.edge('idgxml', 'indesign')
G.edge('indesign', 'pdffile')

G.edge('rv', 'pdf', ltail='cluster_project')
G.edge('pdf', 'latex')
G.edge('latex', 'pdffile')

G.edge('rv', 'plaintext', ltail='cluster_project')
G.edge('rv', 'text', ltail='cluster_project')
G.edge('plaintext', 'morph')
G.edge('text', 'handdtp')

G.edge('markdown', 'md2review')
G.edge('md2review', 'rv')

G.edge('sphinx', 'rvbuilder')
G.edge('rvbuilder', 'rv')
#G.edge('rv', 'rst')
#G.edge('rst', 'sphinx')

G.edge('preproc', 'rv')

G.attr('edge', minlen='2')
G.edge('init', 'rv', lhead='cluster_project')
G.edge('update', 'rv', lhead='cluster_project')
G.edge('vol', 'rv', lhead='cluster_project')

G.render('diagram')

