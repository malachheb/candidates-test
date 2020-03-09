# frozen_string_literal: true

require 'csv'

module Adomik
  module Challenges
    module DataEngine
      class TaskRunner
        def initialize(input_path, transformations, output_path)
          @input_path = input_path
          @transformations = transformations.sort_by(&:rank)
          @output_path = output_path
        end

        def run
          CSV.open(@input_path, 'r') do |csv|
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
            puts "Action: #{t_name}, schema: [#{new_schema.join(', ')}]"
            previous_schema = new_schema
            action_lambda
          end
          [previous_schema, plan]
        end

        def action(name, params, input_schema)
          case name
          when 'rename_column'
            rename_column(input_schema, params)
          when 'drop_columns'
            drop_columns(input_schema, params)
          when 'add_column_with_default_value'
            add_with_default(input_schema, params)
          when 'convert_to_usd'
            convert_to_usd(input_schema, params)
          else
            raise 'Unknown transformation: ' + name
          end
        end

        def rename_column(input_schema, params)
          input_column = params['column_name']
          output_column = params['new_name']
          check_column_existence(input_schema, input_column)

          output_schema = input_schema.clone
          output_schema[input_schema.index(input_column)] = output_column
          [output_schema, identity]
        end

        def add_with_default(input_schema, params)
          if input_schema.include?(params['column_name'])
            [input_schema, identity]
          else
            act = lambda do |r|
              r + [params['default_value']]
            end
            output_schema = input_schema + [params['column_name']]
            [output_schema, act]
          end
        end

        def convert_to_usd(input_schema, params)
          rates = params['rates']
          currency_column = params['currency_column']
          value_column = params['column_name']
          check_column_existence(input_schema, value_column)
          check_column_existence(input_schema, currency_column)

          rate = lambda do |wanted_rate|
            result = rates.select { |rate| rate['currency'] == wanted_rate }.first
            raise "Currency rate not found #{wanted_rate}" if result.nil?

            result['rate']
          end

          act = lambda do |row|
            currency = row[input_schema.index(currency_column)]
            value = row[input_schema.index(value_column)].to_f
            r = row.clone

            r[input_schema.index(value_column)] = value * rate.call(currency)
            r
          end

          [input_schema, act]
        end

        def check_column_existence(schema, column_name)
          raise "The input data does not contain #{column_name}" unless schema.include?(column_name)
        end

        def drop_columns(input_schema, params)
          return [input_schema, ->(r) { r }] if params.empty?

          previous_schema = input_schema
          actions = params.uniq.map do |dropped|
            new_schema, action = drop_column(previous_schema, dropped)
            previous_schema = new_schema
            action
          end

          act = lambda do |row|
            actions.inject(row) do |r, action|
              action.call(r)
            end
          end
          [previous_schema, act]
        end

        def identity
          ->(r) { r }
        end

        def drop_column(input_schema, dropped)
          check_column_existence(input_schema, dropped)

          output_schema = input_schema - [dropped]
          act = lambda do |row|
            r = row.clone
            r.delete_at(input_schema.index(dropped))
            r
          end
          [output_schema, act]
        end
      end
    end
  end
end
