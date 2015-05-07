# Copyright (c) 2015 Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.

module MySQLExpectations
  module Matchers
    # A matcher that checks a table's collation
    #
    class DatabaseHaveTable
      attr_reader :expected_table, :database

      def initialize(expected_table)
        @expected_table = expected_table
        @table = nil
      end

      def matches?(database)
        @database = database
        database.table?(expected_table)
      end

      def description
        "have table '#{expected_table}'"
      end

      def failure_message
        "expected '#{database.name}' database to have table " \
          "'#{expected_table}'"
      end

      def failure_message_when_negated
        "expected '#{database.name}' database not to have table " \
          "'#{expected_table}'"
      end
    end
  end
end
