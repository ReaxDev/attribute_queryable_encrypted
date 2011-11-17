module AttributeQueryableEncrypted
  module CoreExt
    module Prefix
      # Returns an integer of the available length provided
      # a fixed or percentage-based requested length, or self's
      # length, whichever is lowest.
      # 
      # Examples
      # "This is a string".prefix_length #=> 8
      # "This is a string".prefix_length(1000) => 16
      # "This is a string".prefix_length("75%") => 12
      # 
      def prefix_length(requested_length)
        requested_length.is_a?(Numeric) ? length.lower(requested_length) : (length/(100/requested_length.match(/^([0-9.]+)%?$/)[0].to_f)).ceil
      end

      def prefix(requested_length)
        self[0, prefix_length(requested_length)]
      end
    end
  end
end

String.send(:include, AttributeQueryableEncrypted::CoreExt::Prefix)