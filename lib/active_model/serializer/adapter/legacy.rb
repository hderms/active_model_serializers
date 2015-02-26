module ActiveModel
  class Serializer
    class Adapter
      class Legacy < Adapter
        def serializable_hash(options = {})
          if serializer.respond_to?(:each)
            @result = serializer.map{|s| self.class.new(s).serializable_hash }
          else
            @result = serializer.attributes(options)

            serializer.each_association do |name, association, opts|
              if association.respond_to?(:each)
                array_serializer = association
                @result["#{name.singularize}_ids"] = array_serializer.map { |item| item.id }
                add_to_root_body(name,  array_serializer.map { |item| item.attributes(opts) })
              else
                if association
                  @result[name] = association.attributes(options)
                else
                  @result[name] = nil
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
