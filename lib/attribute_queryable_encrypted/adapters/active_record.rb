module AttributeQueryableEncrypted
  module Adapters
    module ActiveRecord
      extend ActiveSupport::Concern

      include AttributeQueryableEncrypted::PrefixAttributes
      
      included do
        attrbute_queryable_encrypted_default_options[:encode] = true
      end
      
      module ClassMethods
        def attribute_queryable_encrypted *args
          define_attribute_methods rescue nil
          super *args
          
          args.reject { |arg| arg.is_a?(Hash) }.each do |attribute|
            options = queryable_encrypted_attributes[attribute]
            
            find_all_by_method = proc do |prefix_value|
              send("find_all_by_#{[options[:prefix], attribute, options[:suffix]].join('_')}", prefix_encrypt(prefix_value, options))
            end

            find_by_method = proc do |original_value| 
              send("find_all_by_#{[options[:prefix], attribute].join('_')}", original_value.prefix(options[:length])).detect do |result|
                result[attribute] === original_value
              end
            end
            
            singleton = class << self
              self
            end
            
            alias_method "original_find_by_#{attribute}", "find_by_#{attribute}" if respond_to?(attribute)
            
            singleton.send(:define_method, "find_all_by_#{[options[:prefix], attribute].join('_')}", find_all_by_method)            
            singleton.send(:define_method, "find_by_#{attribute}", find_by_method)

          end
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, AttributeQueryableEncrypted::Adapters::ActiveRecord)