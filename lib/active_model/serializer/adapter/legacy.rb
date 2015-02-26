module ActiveModel
  class Serializer
    class Adapter
      class Legacy < Adapter
        attr_accessor :root_body, :result
        def serializable_hash(options = {})
          if serializer.respond_to?(:each)
            serializer =  self.class.new(s)
            serialized_hash = serializer.serializable_hash
            @result = serializer.map{|s| serializer.result }
            add_to_root_body(root, serializer.root_body)
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
