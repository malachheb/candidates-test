# frozen_string_literal: true

module Adomik
  module Challenges
    module DataEngine
      # TransformationTemplate define a template for a set of transformation
      class TransformationTemplate
        attr_reader :name, :required_params, :errors

        def initialize(name, required_params)
          @name = name
          @required_params = required_params
          @errors = []
        end

        def validate
          # validation name presence
          # validation required_params
          @errors.empty?
        end
      end
    end
  end
end
