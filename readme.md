AttributeQueryableEncrypted
===========================
Assigns a digest-hashed value to an attribute writer using a portion of the value assigned to each attribute's normal writer. The digest-hashed prefix can then be used to identify other objects with the same prefix without revealing the underlying value.

AttributeQueryableEncrypted was inspried by shuber's excellent [attr_encrypted](https://github.com/shuber/attr_encrypted) gem, and aims for compatibility. It attempts to addresses a shortcoming of encryption, where encrypted columns are queryable when unsalted, but attackable using a precomputed "rainbow table".

Selecting multiple candidates with matching prefix digests and subsequently decrypting the full salted/encrypted data field to find a exact match will reduce the need for a full table scan. You should use attr_encrypted, or your own crypto logic, to handle encrypting and decrypting the appropriate full data field.

Example:
--------
    class HiddenValue                                                              
      include AttributeQueryableEncrypted::PrefixAttributes                                                        
      attr_accessor :prefix_data_digest
      attribute_queryable_encrypted :data
      
      def data=(something)
        ...something fancy that obscures the data...
      end
    end                                                                            
                                                                                 
    hider = HiddenValue.new                                                        
                                                                                 
    hider.data = "This is a string"                                                
    hider.prefix_data_digest                                                       
      # => "a37010c994067764d86540bf479d93b4d0c3bb3955de7b61f951caf2fd0301b0"      


ActiveRecord:
-------------
ActiveRecord users gain a query method for their prefix digest column:

      HiddenValue.find_all_by_prefix_data("This is ")
      # => [#<HiddenValue id: 1, encrypted_data: "MWE2ODg0ZTVmNTA2M2I3MTZmMWQxZGI3NzA0MjgyMzRj...", prefix_data_digest: "MTgyODBlMWFkNGZiMjAyZTc5Y2FiYTcxODZhYTg1OWM3OGNhOWI...">, #<HiddenValue id: 2, encrypted_data: "WQxZGI3NzANTA2M2I3MTZmMj0MjgyMzRMWE2ODg0ZTVm...", prefix_data_digest: "MTgyODBlMWFkNGZiMjAyZTc5Y2FiYTcxODZhYTg1OWM3OGNhOWI...">]

The returned records - a subset of the full table - can then be iterated over to find an exact match.

A convenience method is provided to do this for you - note that it requires an attribute getter method (but not necessarily a database column) that provides a cleartext match for your query argument:

      HiddenValue.find_by_prefix_data("This is a string")
      # => #<HiddenValue id: 1, encrypted_data: "MWE2ODg0ZTVmNTA2M2I3MTZmMWQxZGI3NzA0MjgyMzRj...", prefix_data_digest: "MTgyODBlMWFkNGZiMjAyZTc5Y2FiYTcxODZhYTg1OWM3OGNhOWI...">

You'll need to create an appropriately-named prefix digest column on your own.


Options:
--------
* :length     - an integer value length, or percentage expressed as a string ("72%"). Default is "50%".
* :prefix     - prefix name for the storage accessor. Default is "prefix"
* :suffix     - suffix name for the storage accessor. Defuault is "suffix"
* :encode     - Base64 encode the digest hash, suitable for database persistence. Default is false.
* :stretches  - an integer number of iterations through the digest algorithm. More will reduce the ease of a precomputed attack. Default is 3.
* :key        - an optional key to salt the digest algorithm. Default is nil.

If you choose to use :stretches and/or :key, you should keep their values secret.

Requirements:
-------------
* ActiveSupport >= 3.0
* ActiveRecord >= 3.0 for ActiveRecord usage

Warnings
--------
* This technique is not without shortcomings, notably that the entire prefix digest is subject to a precomputed attack. 
* You should consider using secret values for :stretches and :key, and setting the :length option to a level that obscures an appropriate amount of your data without potentially giving away too much.
* Increasing :stretches incurs a small performance penalty.
* Decreasing :length can return more records in the initial matched set, potentially decreasing performance. Increasing :length makes more of the data subject to a precomputed attack.

Copyright
---------
(The MIT License)

&copy; 2011 (Scott Burton, ChaiOne)