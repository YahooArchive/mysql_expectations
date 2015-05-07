# Copyright (c) 2015 Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.

require_relative 'table'

module MySQLExpectations
  # Allows assertions on a database
  #
  class Database
    attr_reader

    def initialize(database_element)
      @database_element = database_element
    end

    def name
      @database_element.attributes['name']
    end

    def table?(name)
      query = "table_structure[@name='#{name}']"
      !@database_element.elements[query].nil?
    end

    alias_method :has_table?, :table?

    def table(name)
      query = "table_structure[@name='#{name}']"
      table_element = @database_element.elements[query]
      Table.new table_element if table_element
    end

    def tables
      query = 'table_structure'
      tables = []
      @database_element.elements.each(query) do |table_element|
        tables << Table.new(table_element)
      end
      tables
    end

    def method_missing(method, *arguments, &block)
      if arguments.empty? && block.nil?
        table_name = method.to_s
        return table(table_name) if table?(table_name)
      end
      super
    end

    def respond_to_missing?(method, *)
      table?(method.to_s) || super
    end
  end
end
