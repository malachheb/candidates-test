# frozen_string_literal: true

require 'spec_helper'
require 'adomik/challenges/data_engine/transformation'
require 'adomik/challenges/data_engine/transformation_template'
require 'adomik/challenges/data_engine/task_runner'

describe Adomik::Challenges::DataEngine::Transformation do
  describe '.initialize' do
    it 'should work' do
      rename_column = TransformationTemplate(
        name: 'rename_column',
        required_params: {
          column_name: 'String',
          new_name: 'String'
        }
      )
      
      drop_columns = TransformationTemplate(
        name: 'rename_column',
        required_params: ['String']
      )
      
      add_column_with_default_value = TransformationTemplate(
        name: 'add_column_with_default_value',
        required_params: {
          column_name: 'String',
          default_value: 'Any'
        }
      )
      
      convert_to_usd = TransformationTemplate(
        name: 'convert_to_usd',
        required_params: {
          column_name: 'String',
          currency_column: 'String',
          rates: [{currency: 'String', rate: 'Float' }]
        }
      )
      
      
      transformations = [
        Transformation.new(drop_columns, 1, ['transaction_type']),
        Transformation.new(rename_column, 2, {
          column_name: 'seller_revenue',
          new_name: 'revenue'
        }),
        Transformation.new(add_column_with_default_value, 3, {
          column_name: 'currency',
          default_value: 'EUR'
        }),
        Transformation.new(convert_to_usd, 4, {
          column_name: 'revenue',
          currency_column: 'currency',
          rates: [
            {currency: 'EUR', rate: 1.12 },
            {currency: 'ARS', rate: 0.02 },
            {currency: 'CNY', rate: 0.14 }
          ]
        }),
        Transformation.new(drop_columns, 1, ['currency']),
          Transformation.new(add_column_with_default_value, 5, {
          column_name: 'currency',
          default_value: 'USD'
        }),
      ]
      
      input_path = 'input.csv'
      output_path = 'output.csv'
      
      TaskRunner(
        input_path, # the csv input path
        transformations, # an Array of transformation
        output_path, # the csv output path
      )
      
    end
  end
end
