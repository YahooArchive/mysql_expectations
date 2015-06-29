# Copyright (c) 2015 Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.

require 'mysql_expectations/matchers/database_have_table'
require 'mysql_expectations/matchers/database_only_have_tables'
require 'mysql_expectations/matchers/table_have_collation'
require 'mysql_expectations/matchers/table_have_engine_type'
require 'mysql_expectations/matchers/table_have_field'
require 'mysql_expectations/matchers/table_have_key'

# rubocop:disable Style/PredicateName

module MySQLExpectations
  # Allows assertions on a database
  #
  module Matchers
    ####################
    # Database Matchers
    ####################

    def have_table(expected_table_name)
      DatabaseHaveTable.new(expected_table_name)
    end

    def only_have_tables(*expected_table_names)
      DatabaseOnlyHaveTables.new(*expected_table_names)
    end

    ####################
    # Table Matchers
    ####################

    def have_collation(expected_collation)
      TableHaveCollation.new(expected_collation)
    end

    def have_engine_type(expected_engine_type)
      HaveEngineType.new(expected_engine_type)
    end

    def have_field(expected_field_name)
      HaveField.new(expected_field_name)
    end

    def have_key(expected_key)
      HaveKey.new(expected_key)
    end
  end
end
