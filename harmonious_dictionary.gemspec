# -*- encoding: utf-8 -*-
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "harmonious_dictionary/version"

Gem::Specification.new do |s|
  s.name        = "harmonious_dictionary"
  s.version     = HarmoniousDictionary::VERSION
  s.authors     = ["nby"]
  s.email       = ["835482737@qq.com"]
  s.homepage    = "https://github.com/nbyun/small_harmonious_dictionary.git"
  s.summary     = %q{filter any words that need to be harmonized}
  s.description = %q{private gem}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "bundler", "~> 1.6"
  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"

end
