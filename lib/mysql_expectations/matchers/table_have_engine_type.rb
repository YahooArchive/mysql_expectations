# Copyright (c) 2015 Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.

module MySQLExpectations
  module Matchers
    # A matcher that check a table's engine type
    #
    class HaveEngineType
      attr_reader :expected_engine_type, :table

      def initialize(expected_engine_type)
        @expected_engine_type = expected_engine_type
        @table = nil
      end

      def actual_engine_type
        table.engine_type
      end

      def matches?(table)
        @table = table
        actual_engine_type == expected_engine_type
      end

      def description
        "have engine type '#{expected_engine_type}'"
      end

      def failure_message
        "expected '#{table.name}' table engine type to be " \
          "'#{expected_engine_type}' " \
          "but it was '#{actual_engine_type}'"
      end
    end
  end
end
