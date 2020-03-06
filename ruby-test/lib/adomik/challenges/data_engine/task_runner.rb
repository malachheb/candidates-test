require 'csv'

module Adomik
  module Challenges
    module DataEngine
      class TaskRunner
        def initialize(input_path, transformations, output_path)
          @input_path = input_path
          @transformations = transformations.sort_by { |t| t.rank}
          @output_path = output_path
        end

        def run
          CSV.open(@input_path, "r") do |csv|
            header = csv.shift
            output_schema, plan = generate_plan(header)
            puts output_schema.join(',')
            csv.each do |row|
              puts apply_plan(plan, row).join(',')
            end
          end
          
        end

        private

        def apply_plan(plan, row)
          plan.inject(row) do |r, action|
            action.call(r)
          end
        end

        def generate_plan(input_schema)
          previous_schema = input_schema
          plan = @transformations.map do |transformation|
            t_name = transformation.transformation_template.name
            new_schema, action_lambda = action(t_name, transformation.params, previous_schema)
            previous_schema = new_schema
            action_lambda
          end
          [previous_schema, plan]
        end

        def action(name, params, input_schema)
          case name
          when 'rename_column'
            rename_column(input_schema, params)
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
          [output_schema, lambda { |r| r}]
        end
      end
    end
  end
end
