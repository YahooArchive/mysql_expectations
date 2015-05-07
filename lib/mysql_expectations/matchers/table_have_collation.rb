# Copyright (c) 2015 Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.

module MySQLExpectations
  module Matchers
    # A matcher that checks a table's collation
    #
    class TableHaveCollation
      attr_reader :expected_collation, :table

      def initialize(expected_collation)
        @expected_collation = expected_collation
        @table = nil
      end

      def actual_collation
        table.collation
      end

      def matches?(table)
        @table = table
        actual_collation == expected_collation
      end

      def description
        "have collation '#{expected_collation}'"
      end

      def failure_message
        "expected '#{table.name}' table to have collation " \
          "'#{expected_collation}' but it was '#{table.collation}'"
      end
    end
  end
end
