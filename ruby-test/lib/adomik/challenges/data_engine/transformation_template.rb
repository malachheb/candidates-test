require 'adomik/challenges/data_engine/helpers'
# frozen_string_literal: true

module Adomik
  module Challenges
    module DataEngine
      # TransformationTemplate define a template for a set of transformation
      class TransformationTemplate
        attr_reader :name, :required_params, :errors

        def initialize(name, required_params)
          @name = name
          @required_params = JSON.parse(required_params.to_json)
          @errors = []
        end

        def validate
          @errors = []
          validate_type(required_params)

          @errors.empty?
        end

        private

        def validate_type(type)
          if type.is_a?(String)
            validate_string(type)
          elsif type.is_a?(Hash)
            type.values.all? { |t| validate_type(t) }
          elsif type.is_a?(Array)
            validate_array(type)
          else
            @errors << 'Required params must be either Hash, String or Array'
            false
          end
        end

        def validate_array(type)
          @errors << "Array must contain exactly one element #{type.to_json}" unless type.length == 1
          validate_type(type[0])
        end

        def validate_string(type)
          if get_class(type).nil?
            @errors << "Type #{type} does not exist"
            false
          else
            true
          end
        end
      end
    end
  end
end
