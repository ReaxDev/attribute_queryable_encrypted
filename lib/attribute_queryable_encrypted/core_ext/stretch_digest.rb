module AttributeQueryableEncrypted
  module CoreExt
    module StretchDigest
      def stretch_digest(options={})
        options[:digest] ||= Digest::SHA2
        options[:stretches] ||= 1
        
        digest = options[:digest].new
        options[:stretches].times do
          string = options[:key] ? self + options[:key] : self
          digest.update(string)
        end
        digest.to_s
      end
    end
  end
end

String.send(:include, AttributeQueryableEncrypted::CoreExt::StretchDigest)