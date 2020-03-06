# frozen_string_literal: true

module Adomik
  module Challenges
    module DataEngine
      # Transformation define a  transformation created from a TransformationTemplate
      class Transformation
        attr_reader :rank, :params, :transformation_template, :errors

        def initialize(transformation_template, rank, params)
          @transformation_template = transformation_template
          @rank = rank
          @params = params
          @errors = []
        end

        def validate
          # validation logic
          @errors.empty?
        end
      end
    end
  end
end
