module AttributeQueryableEncrypted
  module PrefixAttributes
    extend ActiveSupport::Concern

    included do
      class_attribute :queryable_encrypted_attributes, :attrbute_queryable_encrypted_default_options
      self.queryable_encrypted_attributes = {}
      self.attrbute_queryable_encrypted_default_options = {
        :length     => "50%",
        :prefix     => "prefix",
        :suffix     => "digest",
        :encode     => false,
        :stretches  => 3
      }
    end

    module ClassMethods
      
      # Assigns a digest-hashed value to an attribute writer using a portion of the 
      # value assigned to each attribute's normal writer. The digest-hashed prefix
      # can then be used to identify other objects with the same prefix without
      # revealing the underlying value.
      # 
      # Example:
      # --------
      #   class HiddenValue                                                              
      #     include AttributeQueryableEncrypted::PrefixAttributes                        
      #     attr_writer :data                                                            
      #     attr_accessor :prefix_data_digest                                            
      #     attribute_queryable_encrypted :data                                          
      #   end                                                                            
      #                                                                                  
      #   hider = HiddenValue.new                                                        
      #                                                                                  
      #   hider.data = "This is a string"                                                
      #   hider.prefix_data_digest                                                       
      #     # => "a37010c994067764d86540bf479d93b4d0c3bb3955de7b61f951caf2fd0301b0"      
      # 
      # This technique is valuable when the queryable encrypted attribute is not 
      # persisted, or is persisted in a non-deterministic way (i.e. a salted, encrypted 
      # database column)
      # 
      # 
      # Options:
      # --------
      # :length - an integer value length, or percentage expressed as a string ("72%")
      # :prefix - prefix name for the storage accessor. Default is "prefix"
      # :suffix - suffix name for the storage accessor. Defuault is "suffix"
      # :encode - Base64 encode the digest hash, suitable for database persistence. Default is false.
      # 
      def attribute_queryable_encrypted *attributes
        
        options = attrbute_queryable_encrypted_default_options.merge(attributes.extract_options!)
        
        attributes.each do |attribute|
          queryable_encrypted_attributes[attribute] = options
          class_eval do
            alias_method "unprefixed_#{attribute}=".to_sym, "#{attribute}=".to_sym

            define_method "#{attribute}=", lambda {|*args, &blk|
              send("#{[options[:prefix], attribute, options[:suffix]].join('_')}=".to_sym, prefix_encrypt(args[0], options))
              send("unprefixed_#{attribute}=".to_sym, *args, &blk)
            }
          end
        end
      end
      
      def prefix_encrypt(value, options)
        prefix_encrypted_value = value.prefix(options[:length]).stretch_digest(options)
        # prefix_encrypted_value = [prefix_encrypted_value].pack("m*") if options[:encode]
        prefix_encrypted_value = Base64.strict_encode64(prefix_encrypted_value) if options[:encode]
        prefix_encrypted_value
      end
    end
    
    module InstanceMethods
      def prefix_encrypt(value, options)
        self.class.prefix_encrypt(value, options)
      end
    end
  end
end