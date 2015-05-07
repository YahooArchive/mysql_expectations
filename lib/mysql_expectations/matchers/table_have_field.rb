# Copyright (c) 2015 Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.

module MySQLExpectations
  module Matchers
    # A matcher that checks if a MySQLDumpExpectations::Table has a field.
    # Optionally, checks the field type and nullability
    #
    class HaveField
      attr_reader :expected_field_name, :expected_type
      attr_reader :expected_nullable, :table

      def initialize(expected_field_name)
        @expected_field_name = expected_field_name
        @expected_type = nil
        @expected_nullable = nil
        @table = nil
      end

      def field_match?
        table.field?(expected_field_name)
      end

      def actual_type
        table.field(expected_field_name).type
      end

      def type_match?
        if field_match? && !expected_type.nil?
          return actual_type == expected_type
        end
        true
      end

      def actual_nullable
        table.field(expected_field_name).nullable?
      end

      def nullable_match?
        if field_match? && !expected_nullable.nil?
          return actual_nullable == expected_nullable
        end
        true
      end

      def matches?(table)
        @table = table
        field_match? && type_match? && nullable_match?
      end

      def description
        description = "have field '#{expected_field_name}'"
        description << " of type '#{expected_type}'" if expected_type
        description << ' that is nullable' if expected_nullable == true
        description << ' that is not nullable' if expected_nullable == false
        description
      end

      def field_error(negated: false)
        "expected '#{table.name}' table" \
          " #{negated ? 'not ' : ''}to "\
          "have field '#{expected_field_name}'."
      end

      def type_error
        "expected '#{table.name}.#{expected_field_name}' field " \
          "to be of type '#{expected_type}' but it was '#{actual_type}'"
      end

      def nullable_error
        message = "expected '#{table.name}.#{expected_field_name}' field "
        message << 'to be '
        message << 'not ' unless expected_nullable
        message << 'nullable but it was '
        message << 'not ' unless actual_nullable
        message << 'nullable.'
        message
      end

      def failure_message
        return field_error unless field_match?
        return type_error unless type_match?
        return nullable_error unless nullable_match?
      end

      def failure_message_when_negated
        field_error(negated: true)
      end

      def of_type(expected_type)
        @expected_type = expected_type
        self
      end

      def that_is_nullable
        @expected_nullable = true
        self
      end

      def that_is_not_nullable
        @expected_nullable = false
        self
      end
    end
  end
end
