# Copyright (c) 2015 Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.

require 'mysql_expectations/array_refinements'
require 'mysql_expectations/mysql'
require 'mysql_expectations/database'
require 'mysql_expectations/table'
require 'mysql_expectations/field'
require 'mysql_expectations/key'
require 'mysql_expectations/key_field'
require 'mysql_expectations/matchers'
require 'mysql_expectations/version'

require 'rspec'

RSpec.configure do |config|
  config.include MySQLExpectations::Matchers
end
