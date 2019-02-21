require 'benchmark'
require_relative '../lib/harmonious_dictionary'

puts "-----------测试30个字符20次----------"
text = ''
File.open(File.join(File.dirname(__FILE__), "30_words.txt"), "r") { |f| text = f.read }

n = 20
Benchmark.bm do |x|
  x.report {1.upto(n) do ; HarmoniousDictionary.clean(text); end }
end
puts "-----------测试html文档片段-------------"
html = ''
File.open(File.join(File.dirname(__FILE__), "html_words.txt"), "r") { |f| html = f.read }
Benchmark.bm do |x| 
  x.report { HarmoniousDictionary.clean(html) }
end