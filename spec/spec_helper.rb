# Copyright (c) 2015 Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'mysql_expectations'

include MySQLExpectations

require 'rspec/collection_matchers'
