# Copyright (c) 2015 Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.

module MySQLExpectations
  # Allows assertions on a database
  #
  class Field
    def initialize(field_element)
      @field_element = field_element
    end

    def name
      @field_element.attributes['Field']
    end

    def definition?(expected_options)
      expected_options.each do |expected_key, expected_value|
        value = @field_element.attributes[expected_key]
        return false if value.nil? || value != expected_value
      end
      true
    end

    alias_method :has_definition?, :definition?

    def type
      @field_element.attributes['Type']
    end

    def type?(expected_type)
      expected_type == type
    end

    alias_method :has_type?, :type?

    def nullable?
      @field_element.attributes['Null'] == 'YES'
    end
  end
end
