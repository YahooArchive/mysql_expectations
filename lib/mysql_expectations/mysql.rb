# Copyright (c) 2015 Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.

require 'rexml/document'
require 'mysql_expectations/database'

module MySQLExpectations
  # The database_structure_file should be an XML file resulting from the
  # mysqldump command:
  #
  # mysqldump --xml --no-data --all-databases \
  #   --host=#{env.host} --port=#{env.port} \
  #   --user=#{env.username}
  #
  class MySQL
    def initialize(source)
      @doc = REXML::Document.new(source)
    end

    def database?(name)
      query = "mysqldump/database[@name='#{name}']"
      !@doc.elements[query].nil?
    end

    alias_method :has_database?, :database?

    def database(name)
      query = "mysqldump/database[@name='#{name}']"
      database_element = @doc.elements[query]
      Database.new database_element if database_element
    end

    def databases
      query = 'mysqldump/database'
      databases = []
      @doc.elements.each(query) do |database_element|
        databases << Database.new(database_element)
      end
      databases
    end

    def method_missing(method_sym, *arguments, &block)
      if arguments.empty? && block.nil?
        database_name = method_sym.to_s
        return database(database_name) if database?(database_name)
      end
      super
    end

    def respond_to_missing?(method, *)
      database?(method.to_s) || super
    end
  end
end
