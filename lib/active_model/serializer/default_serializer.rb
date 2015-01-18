module ActiveModel
  class Serializer
    class DefaultSerializer < Serializer
      def attributes(*)
        object
      end
    end
  end
end
