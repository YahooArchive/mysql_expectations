# Copyright (c) 2015 Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.

module MySQLExpectations
  module Matchers
    # A matcher that checks if a MySQLDumpExpectations::Table has a field.
    # Optionally, checks the field type and nullability
    #
    class HaveKey
      attr_reader :expected_key, :table

      def initialize(expected_key)
        @expected_key = expected_key
        @table = nil
      end

      def matches?(table)
        @table = table
        @table.key?(expected_key.name) &&
          @table.key(expected_key.name) == expected_key
      end

      def description
        description = "have key #{expected_key}"
        description
      end

      def current_keys(keys)
        result = ''
        keys.each_with_index do |key, index|
          result << key.to_s
          result << ",\n" unless index == keys.size - 1
        end
        result
      end

      def failure_message
        result = "expected '#{table.name}' table to " \
          "have key #{expected_key}"
        keys = table.keys
        if keys.empty?
          result << ' but it has no keys.'
        else
          result << " but it has keys:\n"
          result << current_keys(keys)
        end
        result
      end
    end
  end
end
