# frozen_string_literal: true

def get_class(class_name)
  klass = Module.const_get(class_name)
  return nil unless klass.is_a?(Class)

  klass
rescue NameError
  nil
end
