require 'test_helper'

module ActionController
  module Serialization
    class PrimitiveSerializationTest < ActionController::TestCase
      class MyController < ActionController::Base
        def render_array
          render json: ['value1', 'value2']
        end

        def render_hash
          render json: {key1: 'value1', key2: 'value2'}
        end
      end

      tests MyController

      def test_render_array
        get :render_array

        assert_equal 'application/json', @response.content_type
        assert_equal '["value1","value2"]', @response.body
      end

      def test_render_hash
        get :render_hash

        assert_equal 'application/json', @response.content_type
        assert_equal '{"key1":"value1","key2":"value2"}', @response.body
      end
    end
  end
end

