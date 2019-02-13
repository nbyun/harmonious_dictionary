# encoding: utf-8

require File.expand_path("lib/harmonious_dictionary/rseg.rb")
require File.expand_path("lib/harmonious_dictionary/version")

module HarmoniousDictionary
  def self.clean?(input)
    results = HarmoniousDictionary::Rseg.segment(input)
    results.size > 0 ? false : true
  end

  def self.clean(input)
    results = HarmoniousDictionary::Rseg.segment(input)
    results.each{|result| input.gsub! /#{result}/,self.clean_word_basic(result) }
    input
  end

  def self.harmonious_words(input)
    return HarmoniousDictionary::Rseg.segment(input)
  end

  def self.clean_word_basic(word)
    clearn_words = ""
    word.size.times{  clearn_words << "*" }
    clearn_words
  end

  def self.chinese_harmonious
    Rseg.instance.send(:engines).first.dictionary
  end
end
