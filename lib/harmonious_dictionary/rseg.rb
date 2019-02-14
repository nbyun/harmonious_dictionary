# encoding: utf-8

require 'singleton'
require 'net/http'
require 'yaml'

require File.join(File.dirname(__FILE__), 'engines/engine')
require File.join(File.dirname(__FILE__), 'engines/dict')
require File.join(File.dirname(__FILE__), 'engines/english')

require File.join(File.dirname(__FILE__), 'filters/fullwidth')
require File.join(File.dirname(__FILE__), 'filters/symbol')
require File.join(File.dirname(__FILE__), 'filters/conjunction')

module HarmoniousDictionary
  class Rseg
    include Singleton
    include RsegEngine
    include RsegFilter
    attr_writer :input
    
    class << self    
      def segment(input)
        HarmoniousDictionary::Rseg.instance.input = input
        HarmoniousDictionary::Rseg.instance.segment
      end
      
      def load(dict)
        HarmoniousDictionary::Rseg.instance
        nil
      end
    end

    def initialize
      @input = ''
      @words = [] 
    end
    
    def segment
      init_operate
      @words = []
      @input.chars.each do |origin|
        char = filter(origin)
        process(char, origin)
      end
      
      process(:symbol, '')
      @words
    end

    private

    def init_operate
      @chinese_dictionary_path = chinese_dictionary_path
      init_engines
      init_filters
    end

    def filter(char)
      result = char
      @filters.each do |klass|
        result = klass.filter(result)
      end
      result
    end
    
    def process(char, origin)
      nomatch = true
      word = ''
      @english_dictionary ||= load_english_dictionary(english_yaml_path)
      
      engines.each do |engine|
        next unless engine.running?
        match, word = engine.process(char)
        if match 
          nomatch = false
        else
          word = '' if engine.class == English && !@english_dictionary.include?(word)
          engine.stop 
        end
      end
      
      if nomatch
        if word == ''
          # 没切出来的就当正常的词，不输出
          # @words << origin unless char == :symbol 
          reset_engines
        else
          reset_engines
          @words << word if word.is_a?(String) if word.size >= 2
          # 我们只需要脏词完全匹配，不需要检查下文
          # reprocess(word) if word.is_a?(Array)
          # re-process current char
          process(char, origin)
        end
      end
    end
    
    def reprocess(word)
      last = word.pop

      word.each do |char|
        process(char, char)
      end
      
      process(:symbol, :symbol) # 把词加进来
      process(last, last) # 继续分析词的最后一个字符
    end

    def reset_engines
      engines.each do |engine|
        engine.run
      end
    end
    
    def engines=(engines)
      @engines ||= engines
    end

    def engines
      @engines
    end

    def init_filters
      @filters = [Fullwidth, Symbol]
    end
    
    def init_engines
      @engines ||= [Dict, English].map do |engine_klass|
        if engine_klass == Dict
          engine_klass.new do
            @dict_path = @chinese_dictionary_path 
          end
        else 
          engine_klass.new
        end
      end
    end

    def load_english_dictionary(path)
      begin
        YAML.load(File.read(path))
      rescue => e
        puts e
        exit
      end
    end

    def english_yaml_path
      File.join(Padrino.root, 'config/harmonious_dictionary/harmonious_english.yml')
    end

    def chinese_dictionary_path
      File.join(Padrino.root, 'config/harmonious_dictionary/harmonious.hash')
    end
  end
end
