# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "attribute_queryable_encrypted/version"

Gem::Specification.new do |s|
  s.name        = "attribute_queryable_encrypted"
  s.version     = AttributeQueryableEncrypted::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Scott Burton"]
  s.email       = ["scott@chaione.com"]
  s.homepage    = "https://github.com/chaione/attribute_queryable_encrypted"
  s.summary     = %q{Makes querying encrypted & salted attributes mildly less horrible}
  s.description = %q{Makes querying encrypted & salted attributes mildly less horrible}

  s.rubyforge_project = "attribute_queryable_encrypted"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency "active_support", ">= 3.0"
  s.add_development_dependency "rspec"
end
