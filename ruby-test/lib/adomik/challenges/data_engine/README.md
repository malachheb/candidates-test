# Adomik Ruby Challenges




# DataEngine #1

## Introduction

At Adomik we collect a lot of CSV files from many different sources.

The collected CSV have different schemas and different contents. To provide useful data we therefore need to normalize the data.

To make integrating new sources as easy as possible, we need to build the DataEngine. Since adomik is short on resources, we let our candidates build this system for us ! (that was a joke of course)

## Transformations

The idea of the DataEngine is to have a list of **transformations**. Each transformation describes an action on one or more columns of the CSV file and will be executed one after the other.

To catch errors early in the design process we also want to provide a TransformationTemplate that provides basic information about available transformations and some validations to check if the provided parameters are ok.

So to summarize we would like to to have something like this:

  ```  TransformationTemplate(name, required_params) ```
  
  ```  Transformation(transformation_template, rank, params) ```

TransformationTemplate
  - The required_params define the parameters needed by the transformation to be done and also their types.
  - required_params
    - The required params accepts the following types:
      -  Hash, Array, Integer, String, Float, Class ( a ruby defined class )
    - For a Hash in the required params, the key represents the Hash key ans the value represent the Hash value type.
    - The Array type contains exactly one type.

Transformation
  - transformation_template
    - The template for this transformation
  - rank
    - An integer to specify the order in which the transformations are executed (To persist the documents in a data base)
  - params
    - The arguments to this transformation


```
tt = TransformationTemplate(
  name: rename_column,
  required_params: {old_name: String, new_name: String}"
)
Transformation(
  transformation_template: tt,
  rank: 1,
  params: {old_name: 'col1', new_name: 'col2'}
)

tt = TransformationTemplate(
	name: rename_column,
	required_params: ['Integer']
)
Transformation(
  transformation_template: tt,
  rank: 1,
  params: [12,9,1]
)

user = User.new(name, email)
tt = TransformationTemplate(
       name: rename_column,
       required_params: ['User']
      )
Transformation(
  transformation_template: tt,
  rank: 1,
  params: [user]
)
```

The required params can also contain nested attributes.

```
tt = TransformationTemplate(
  	name: 'convert_to_usd',
    	required_params: {column_name: 'String', currency_column: 'String', rates: [{currency: 'String', rate: 'Float' }]}
)
Transformation(
  transformation_template: tt,
  rank: 1,
  params: {column_name: 'revenue', currency_column: 'curr', rates: [ {currency: 'usd'; rate: 1.2}, {currency: 'eur'; rate: 1.5}]}
)
```

The required params can have an **optional** attribute, in this case the attribute can be absent on with the value nil.

```
tt = TransformationTemplate(
  name: 'convert_to_usd',
  required_params: {
    column_name: { '$optional' => 'String'}},
    currency_column: 'String',
    rates: {'$optional' => [{currency: 'String', rate: 'Float' }]}
  }
)
Transformation(
  transformation_template: tt,
  rank: 1
  params: {column_name: 'revenue', column_currency: 'curr', rates: [ {currency: 'usd'; rate: 1.2}, {currency: 'eur', rate: 1.5}]}
)
```

### Exercise
the goal of this exercise is to implement the two methods validate() in the class 


TransformationTemplate: 
  - validate the the presence of name
  - validate that the required_params have a correct format 

Transformation: 
  - validate the the presence of rank 
  - validate that rank is a positive Integer
  - validate that the params respect the required params type 


## TaskRunner

After defining the Transformation for each CSV file the data operation team must add them to a TaskRunner to transform the input csv to an output csv files with executing each Transformation ordered by rank.

```
TaskRunner(
  input_path, # the csv input path
  transformations, # an Array of transformation
  output_path, # the csv output path
)
```

### Exercise

The goal of the exercise is to provide a design and an implementation to solve this problem.


For this exercise we'll use only these 4 TransformationTemplates: rename_column, delete_columns, add_column_with_default_value (only if it does not exist), convert_to_usd

A collected CSV file can potentially have missing columns, so you must handle the case if a transformation doesn't find a column in the CSV.

On top of the implementation we would like you to implement your own unit tests to make sure your program is working correctly.

Below you will fine an example that should convert the file input.csv to the output we are expecting.


```
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
    rates: [{ currency: 'String', rate: 'Float' }]
  }
)

transformations = [
  DE::Transformation.new(drop_columns, 1, ['transaction_type']),
  DE::Transformation.new(rename_column, 2, {
                            column_name: 'seller_revenue',
                            new_name: 'revenue'
                          }),
  DE::Transformation.new(add_column_with_default_value, 3, {
                            column_name: 'currency',
                            default_value: 'EUR'
                          }),
  DE::Transformation.new(convert_to_usd, 4, {
                            column_name: 'revenue',
                            currency_column: 'currency',
                            rates: [
                              { currency: 'EUR', rate: 1.12 },
                              { currency: 'ARS', rate: 0.02 },
                              { currency: 'CNY', rate: 0.14 }
                            ]
                          }),
  DE::Transformation.new(drop_columns, 5, ['currency']),
  DE::Transformation.new(add_column_with_default_value, 6, {
                            column_name: 'currency',
                            default_value: 'USD'
                          })
]

input_path = 'input_2.csv'
output_path = 'output.csv'

runner = DE::TaskRunner.new(
  input_path, # the csv input path
  transformations, # an Array of transformation
  output_path # the csv output path
)

runner.run
```
