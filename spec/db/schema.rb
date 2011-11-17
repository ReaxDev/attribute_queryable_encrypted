ActiveRecord::Schema.define do
  self.verbose = false

  create_table :test_models, :force => true do |t|
    t.string :data
    t.string :prefix_data_digest
  end
end