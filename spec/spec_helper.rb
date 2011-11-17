$: << ".." << "../lib"
Dir[File.expand_path(File.join(__FILE__, "..", "..", "lib", "attribute_queryable_encrypted.rb"))].each {|file| require file }
require 'rspec'