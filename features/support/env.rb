# Copyright (c) 2015 Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.

require 'mysql_expectations'
require 'aruba/cucumber'

Before do |scenario|
  # Save the scenario name so that steps can use it.
  # @scenario_name is used in env.rb so that code coverage works right.
  #
  case scenario
  when Cucumber::Ast::OutlineTable::ExampleRow
    @scenario_name = scenario.scenario_outline.name
  when Cucumber::Ast::Scenario
    @scenario_name = scenario.name
  else
    fail 'Unhandled class'
  end
end
