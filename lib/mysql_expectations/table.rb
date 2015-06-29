# Copyright (c) 2015 Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.

require 'mysql_expectations/field'
require 'mysql_expectations/key'

module MySQLExpectations
  # Allows assertions on a table
  #
  class Table
    def initialize(table_element)
      @table_element = table_element
    end

    def name
      @table_element.attributes['name']
    end

    def field?(expected_field)
      query =  "field[@Field='#{expected_field}']"
      !@table_element.elements[query].nil?
    end

    alias_method :has_field?, :field?

    def field(name)
      query = "field[@Field='#{name}']"
      field_element = @table_element.elements[query]
      Field.new field_element if field_element
    end

    def fields
      query = 'field'
      fields = []
      @table_element.elements.each(query) do |field_element|
        fields << Field.new(field_element)
      end
      fields
    end

    def option?(expected_options)
      options = @table_element.elements['options']
      expected_options.each do |expected_key, expected_value|
        value = options.attributes[expected_key]
        return false if value.nil? || value != expected_value
      end
    end

    alias_method :has_option?, :option?

    def engine_type
      options = @table_element.elements['options']
      options.attributes['Engine'] if options
    end

    def engine_type?(expected_engine_type)
      engine_type == expected_engine_type
    end

    alias_method :has_engine_type?, :engine_type?

    def collation
      options = @table_element.elements['options']
      options.attributes['Collation'] if options
    end

    def collation?(expected_collation)
      collation == expected_collation
    end

    alias_method :has_collation?, :collation?

    def key?(key_name)
      Key.key?(@table_element, key_name)
    end

    def primary_key?
      key?('PRIMARY')
    end

    def key(key_name)
      Key.load_key(@table_element, key_name)
    end

    def keys
      Key.load_all_keys(@table_element)
    end

    def method_missing(method, *arguments, &block)
      if arguments.empty? && block.nil?
        name = method.to_s
        return field(name) if field?(name)
      end
      super
    end

    def respond_to_missing?(method, *)
      field?(method.to_s) || super
    end
  end
end
