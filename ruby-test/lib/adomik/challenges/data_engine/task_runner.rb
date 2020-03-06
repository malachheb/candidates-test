module Adomik
  module Challenges
    module DataEngine
      class TaskRunner
        def initialize(input_path, transformations, output_path)
          @input_path = input_path
          @transformations = transformations.order_by { |t| t.rank}
          @output_path = output_path
        end

        private

        def generate_plan(input_schema)
          previous_schema = input_schema
          @transformations.map do |transformation|
            t_name = transformation.transformation_template.name
            new_schema, action_lambda = action(t_name, transformation.params, previous_schema)
            previous_schema = new_schema
            action_lambda
          end
        end

        def action(name, params, input_schema)
          case name
          when 'rename_column'
            rename_column(previous_schema, transformation.params)
          else
            raise 'Unknown transformation: ' + name
          end
        end

        def rename_column(input_schema, params)
          input_column = params['column_name']
          output_column = params['new_name']
          raise "The input data does not contain #{input_column}" unless input_schema.include?(input_column)
          output_schema = input_schema.clone
          output_schema[input_schema.index(input_column)] = output_column
          [output_schema, lambda { |_| }]
        end
      end
    end
  end
end
