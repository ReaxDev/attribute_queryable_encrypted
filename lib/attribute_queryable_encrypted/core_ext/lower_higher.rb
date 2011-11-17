module AttributeQueryableEncrypted
  module CoreExt
    module LowerHigher
      # Returns the lower of self or n
      def lower(n)
        self < n ? self : n
      end
  
      # Returns the higher of self or n
      def higher(n)
        self > n ? self : n
      end
    end
  end
end

Numeric.send(:include, AttributeQueryableEncrypted::CoreExt::LowerHigher)