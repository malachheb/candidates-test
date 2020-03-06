# frozen_string_literal: true

require 'spec_helper'
require 'adomik/challenges/data_engine/transformation'
require 'adomik/challenges/data_engine/transformation_template'
require 'adomik/challenges/data_engine/task_runner'

describe Adomik::Challenges::DataEngine::Transformation do
  describe '.initialize' do
    it 'should work' do
      DE = Adomik::Challenges::DataEngine
      rename_column = DE::TransformationTemplate.new(
        'rename_column',
        {
          column_name: 'String',
          new_name: 'String'
        }
      )
      
      drop_columns = DE::TransformationTemplate.new(
        'drop_columns',
        ['String']
      )
      
      add_column_with_default_value = DE::TransformationTemplate.new(
        'add_column_with_default_value',
        {
          column_name: 'String',
          default_value: 'Any'
        }
      )
      
      convert_to_usd = DE::TransformationTemplate.new(
        'convert_to_usd',
        {
          column_name: 'String',
          currency_column: 'String',
          rates: [{currency: 'String', rate: 'Float' }]
        }
      )
      
      
      transformations = [
        # DE::Transformation.new(drop_columns, 1, ['transaction_type']),
        DE::Transformation.new(rename_column, 2, {
          column_name: 'seller_revenue',
          new_name: 'revenue'
        }),
        # DE::Transformation.new(add_column_with_default_value, 3, {
        #   column_name: 'currency',
        #   default_value: 'EUR'
        # }),
        # DE::Transformation.new(convert_to_usd, 4, {
        #   column_name: 'revenue',
        #   currency_column: 'currency',
        #   rates: [
        #     {currency: 'EUR', rate: 1.12 },
        #     {currency: 'ARS', rate: 0.02 },
        #     {currency: 'CNY', rate: 0.14 }
        #   ]
        # }),
        # DE::Transformation.new(drop_columns, 1, ['currency']),
        # DE::Transformation.new(add_column_with_default_value, 5, {
        #   column_name: 'currency',
        #   default_value: 'USD'
        # }),
      ]
      
      input_path = 'input.csv'
      output_path = 'output.csv'
      
      runner = DE::TaskRunner.new(
        input_path, # the csv input path
        transformations, # an Array of transformation
        output_path, # the csv output path
      )

      runner.run
      
    end
  end
end
