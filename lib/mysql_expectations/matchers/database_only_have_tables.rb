# Copyright (c) 2015 Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.

require 'mysql_expectations/array_refinements'

module MySQLExpectations
  module Matchers
    # A matcher that checks what tables are in a database
    #
    class DatabaseOnlyHaveTables
      using ArrayRefinements

      attr_reader :database, :expected_table_names, :actual_table_names

      def initialize(*expected_table_names)
        @expected_table_names = expected_table_names.flatten
        @database = nil
      end

      def liquibase_tables
        %w(DATABASECHANGELOG DATABASECHANGELOGLOCK)
      end

      def actual_table_names
        database.tables.map(&:name) - liquibase_tables
      end

      def matches?(database)
        @database = database
        actual_table_names.sort == expected_table_names.sort
      end

      def description
        "only have tables #{expected_table_names.to_sentence}"
      end

      def additional_tables_message
        message = ''
        unless (actual_table_names - expected_table_names).empty?
          message << ' but had additional tables: '
          message <<
            (actual_table_names - expected_table_names).to_sentence
        end
        message
      end

      def missing_tables_message
        message = ''
        unless (expected_table_names - actual_table_names).empty?
          message << ' but was missing tables: '
          message <<
            (expected_table_names - actual_table_names).to_sentence
        end
        message
      end

      def failure_message
        message = "expected '#{database.name}' "
        message << 'database to only have tables '
        message << expected_table_names.to_sentence
        message << additional_tables_message
        message << missing_tables_message
        message
      end
    end
  end
end
