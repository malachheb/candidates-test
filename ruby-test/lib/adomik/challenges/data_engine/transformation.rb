module Adomik
  module Challenges
    module DataEngine
      # Transformation define a  transformation created from a TransformationTemplate
      class Transformation

        attr_reader :rank, :params, :transformation_template, :errors

        def initialize(transformation_template, rank, params)
          @transformation_template = transformation_template
          @rank = rank
          @params = JSON.parse(params.to_json)
          @errors = []
        end

        def validate
          @errors = []

          @errors << 'Rank must be a positive integer' unless @rank.is_a?(Integer) && rank >= 0
          @errors << 'Transformation template invalid' unless @transformation_template.is_a? TransformationTemplate

          rq = JSON.parse(@transformation_template.required_params.to_json)

          validate_params(rq, @params)

          @errors.empty?
        end

        private

        def validate_params(schema, parameters)
          if is_optional(schema)
            validate_optional(schema, parameters)
          elsif schema.is_a? Hash
            validate_hash(schema, parameters)
          elsif schema.is_a? Array
            validate_array(schema, parameters)
          else
            validate_type(schema, parameters)
          end
        end


        def is_optional(schema)
          schema.is_a?(Hash) && schema.key?('$Optional')
        end

        def validate_optional(schema, parameters)
          if parameters.nil?
            true
          else
            validate_params(schema['$Optional'], parameters)
          end
        end

        def validate_hash(schema, parameters)
          unless parameters.is_a? Hash
            @errors << "Required a hash but found the following #{parameters}"
            return false
          end

          schema.all? do |key, value|
            validate_params(value, parameters[key])
          end
        end

        def validate_array(schema, parameters)
          unless parameters.is_a? Array
            @errors << "Required an array but found the following #{parameters}"
            return false
          end

          unless schema.length == 1
            @errors << "The schema should have the length of 1"
            return false
          end

          parameters.each do |p|
            validate_params(schema[0], p)
          end
        end


        def validate_type(schema, parameters)
          unless schema.is_a? String
            @errors << "The schema can only be described in terms of strings, hashes and arrays"
            return false
          end

          case schema
          when 'String'
            is_type_or_error(parameters, String)
          when 'Float'
            is_type_or_error(parameters, Float)
          when 'Integer'
            is_type_or_error(parameters, Integer)
          else
            validate_class(schema, parameters)
          end
        end

        def is_type_or_error(parameters, type)
          if parameters.is_a? type
            true
          else
            @errors << "#{parameters} is not a #{type}"
            false
          end
        end

        def validate_class(schema, parameters)
          c = get_class(schema)
          if c.nil?
            @errors << "The class #{schema} does not exist"
            false
          elsif
            c.respond_to?(:parameters_valid?)
            c.parameters_valid?(parameters)
          else
            true
          end
        end
      end

    end
  end
end
