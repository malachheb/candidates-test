# Adomik Ruby Challenges




# DataEngine #1

After collecting a CSV files, our data engine apply some transformations to generate a normalized new csv file.
The collected CSV has a different schema and different content that why we need this normalisation step.
To make this task,  the data  operation team must choose from a set of transformation predefined ( transformation Template) to apply for each csv file.

The DataEngine module have two class:

  ```  TransformationTemplate(name, required_params) ```
  
  ```  Transformation(transformation_template, rank, params) ```

  - the required_params must respect a specific schema

  The first required params type must be a Hash or an Array.
  The Hash type contain a key value params, the key represent the Hash key ans the value represent the Hash value type.
  The Array type contain another Type.
  The accepted types:
       
       
       Hash, Array, Integer, String, Float, Class ( a ruby defined class )
       
       

  - The required_params define the params needed by the transformation to be done and also their types.

`
tt = TransformationTemplate(
  name: rename_column,
  required_params: "Hash(old_name: String, new_name: String)"
)
Transformation(
  transformation_template: tt,
  rank: 1,
  params: {old_name: 'col1', new_name: 'col2'}
)

tt = TransformationTemplate(
	name: rename_column,
	required_params: "Array(Integer)"
      )
Transformation(
  transformation_template: tt,
  rank: 1,
  params: [12,9,1]
)

user = User(name, email)
tt = TransformationTemplate(
       name: rename_column,
       required_params: "Array(User)"
      )
Transformation(
  transformation_template: tt,
  rank: 1,
  params: [user]
)
`

- The required params can have a nested attributes also.

`
tt = TransformationTemplate(
  	name: convert_to_usd,
    	required_params: "Hash(column_name: 'String', currency_column: 'String', rates: Array(Hash(currency: 'String', rate: 'Float' )))"
)
Transformation(
  transformation_template: tt,
  rank: 1,
  params: {column_name: 'revenue', column_currency: 'curr', rates: [ {currency: 'usd'; rate: 1.2}, {currency: 'eur'; rate: 1.5}]}
)
`

 - The required params can have an Optional attribute, in this case the attribute can be absent on with value nil.

`
 tt = TransformationTemplate(
   name: convert_to_usd,
     required_params: Hash(Optional(column_name: 'String'), currency_column: 'String', rates: Optional(Array(Hash(currency: 'String', rate: 'Float' ))) )"
)
Transformation(
  transformation_template: tt,
  rank: 1
  params: {column_name: 'revenue', column_currency: 'curr', rates: [ {currency: 'usd'; rate: 1.2}, {currency: 'eur', rate: 1.5}]}
)
`

## Exercice
the goal of this exercise is to implement the two methods validate() in the class 

`
TransformationTemplate: 
 validate the the presence of name
 validate that the required_params have a correct format 

Transformation: 
 validate the the presence of rank 
 validate that rank is a positif Integer
 validate that the params respect the required params type 
 
`

# DataEngine #1

After defining the Transformation for each CSV file the data operation team must add them to a TaskRunner to transform the input csv to an output csv files with executing each Transformation ordered by rank.
`
TaskRunner(
  input_path, # the csv input path
  transformations, # an Array of transformation
  output_path, # the csv output path
)
  `

## Exercice

The goal of the exercise is to provide a design and an implementation to solve this problem. your are free to add any Ruby class you want. 
We need just a class that contains the main method to transform an input CSV file to an output CSV file.

A  collected CSV file can have less or more columns, so you must handle the case if a transformation don't found a column in the CSV.

For this exercise we'll use only these three TransformationTemplate: rename_column, delete_column, add_column_with_default_value, convert_to_usd

