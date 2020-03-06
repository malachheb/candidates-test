module Adomik
  module Challenges
    module DataEngine
      class ExecutionPlan
        def initialize(input_schema, previous_plan)
          @input_schema = input_schema
          @previous_plan = previous_plan
        end

        def execute_on_row(row)
          @previous_plan.execute_on_row(row)
        end

        protected

        def get_field(key, row)
          row[@input_schema.index(key)]
        end
      end
    end
  end
end
