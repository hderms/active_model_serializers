module ActiveModel
  class Serializer
    class Adapter
      class Legacy < Adapter
        attr_accessor :root_body, :result
        def serializable_hash(options = {})
          if serializer.respond_to?(:each)
            serializers = serializer.map{|s| self.class.new(s) }
            serialized_hashes = serializers.map{|s| s.serializable_hash}
            serialized_results = serializers.map{|s| s.result}
            serialized_roots = serializers.map{|s| s.root_body}
            serialized_roots.each do |key, value|
              add_to_root_body(key, value)
            end
            @result = serialized_results
          else
            @result = serializer.attributes(options)

            serializer.each_association do |name, association, opts|
              key_name = "#{name.to_s.singularize}_ids".to_sym
              if association.respond_to?(:each)
                array_serializer = association
                @result[key_name] = array_serializer.map { |item| item.id }
                add_to_root_body(name,  array_serializer.map { |item| item.attributes(opts) })
              else
                if association
                  @result[key_name] = association.attributes(options)
                else
                  @result[key_name] = nil
                end
              end
            end
          end

          if root = options.fetch(:root, serializer.json_key)
            add_to_root_body(root, @result)
          end

          @root_body
        end
      end
    end
  end
end
