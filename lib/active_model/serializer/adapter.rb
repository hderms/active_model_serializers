module ActiveModel
  class Serializer
    class Adapter
      extend ActiveSupport::Autoload
      autoload :Json
      autoload :Null
      autoload :JsonApi
      autoload :Legacy

      attr_reader :serializer

      def initialize(serializer, options = {})
        @serializer = serializer
        @options = options
        @root_body = {}
      end

      def serializable_hash(options = {})
        raise NotImplementedError, 'This is an abstract method. Should be implemented at the concrete adapter.'
      end

      def as_json(options = {})
        hash = serializable_hash(options)
        include_meta(hash)
      end

      def self.create(resource, options = {})
        override = options.delete(:adapter)
        klass = override ? adapter_class(override) : ActiveModel::Serializer.adapter
        klass.new(resource, options)
      end

      def self.adapter_class(adapter)
        "ActiveModel::Serializer::Adapter::#{adapter.to_s.classify}".safe_constantize
      end

      private

      def meta
        serializer.meta if serializer.respond_to?(:meta)
      end

      def meta_key
        serializer.meta_key || "meta"
      end

      def root
        serializer.json_key
      end

      def include_meta(json)
        json[meta_key] = meta if meta && root
        json
      end

      def add_to_root_body(key, values)
        if @root_body[key].respond_to?(:each)
          if values.respond_to?(:each)
            @root_body[key] += values
          else
            @root_body[key] << values
          end
        else
          @root_body.store(key , values)
        end
      end
    end
  end
end
