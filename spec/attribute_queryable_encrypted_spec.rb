require 'spec_helper'

class TestModel
  attr_accessor :default_length_data, :prefix_default_length_data_digest
  attr_accessor :fixed_length_data, :prefix_fixed_length_data_digest
  attr_accessor :percentage_length_data, :prefix_percentage_length_data_digest
  include AttributeQueryableEncrypted::PrefixAttributes
  attrbute_queryable_encrypted_default_options[:encode] = false
end

describe TestModel do
  let(:input_string) {"It's a wicked string"}
  context "without a :length" do
    before(:all) do
      TestModel.attribute_queryable_encrypted :default_length_data
    end
    before(:each) do
      subject.default_length_data = input_string
    end

    its(:prefix_default_length_data_digest) {should eql "bc1b6f5cd503fad53c32b002176ca65f0c7409194ecb987825d6875ce1392aa1"}
    its(:default_length_data) {should eql input_string}
  end
  
  context "with a :length" do
    context "as an integer" do
      before(:all) do
        TestModel.attribute_queryable_encrypted :fixed_length_data, :length => 14
      end
      before(:each) do
        subject.fixed_length_data = input_string
      end

      its(:prefix_fixed_length_data_digest) {should eql "9c0dcb0f5d3429f9ac6c8d7bd1e5b056fb326f677806dbd8d813d046e7f3e764"}
    end
    
    context "as a string percentage" do
      before(:each) do
        TestModel.attribute_queryable_encrypted :percentage_length_data, :length => "75%"
        subject.percentage_length_data = input_string
      end

      its(:prefix_percentage_length_data_digest) {should eql "0594e426cced44e4ea358b0dbc10f71ba622661a43a0f3b460a2437e85b43ddc"}
    end
  end
end