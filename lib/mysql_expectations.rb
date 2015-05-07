# Copyright (c) 2015 Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.

require_relative 'mysql_expectations/array_refinements'
require_relative 'mysql_expectations/mysql'
require_relative 'mysql_expectations/database'
require_relative 'mysql_expectations/table'
require_relative 'mysql_expectations/field'
require_relative 'mysql_expectations/key'
require_relative 'mysql_expectations/key_field'
require_relative 'mysql_expectations/matchers'
require_relative 'mysql_expectations/version'

require 'rspec'

RSpec.configure do |config|
  config.include MySQLExpectations::Matchers
end
