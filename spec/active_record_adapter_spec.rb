require 'active_record'
require 'logger'
require 'spec_helper'

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", 
                                        :database => File.dirname(__FILE__) + "/db/attribute_queryable_encrypted.sqlite3")

ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.logger.level = 3

load File.dirname(__FILE__) + '/db/schema.rb'

class TestModel < ActiveRecord::Base
  attribute_queryable_encrypted :data, :length => 9
end

describe TestModel do
  before(:all) do
    @match1, @match2, @not_match = ["This is a string", "This is another string", "This string doesn't match"].map {|data| TestModel.create(:data => data)}
  end
  
  describe "class query methods" do
    it "finds the model instances with the appropriate prefix data" do
      TestModel.find_all_by_prefix_data("This is a").should eql([@match1, @match2])
    end
    
    it "finds the first exact match for the full original value" do
      TestModel.find_by_data("This is another string").should eql @match2
    end
  end
end