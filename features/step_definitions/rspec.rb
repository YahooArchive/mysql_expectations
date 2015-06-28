# Copyright (c) 2015 Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.

require 'erb'

Given(/^the rspec template for "(.*?)":$/) do |rspec_file, rspec_template|
  @rspec_file = rspec_file
  enable_code_coverage = <<-RUBY
      require 'simplecov'

      SimpleCov.root('../..')

      # make SimpleCov treat each invocation of rspec like a
      # separate test suite so that coverage results are merged
      # together for all tests rather than only getting results
      # of the last test run.
      #
      SimpleCov.command_name "cucumber:scenario:#{@scenario_name}"

      SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
      SimpleCov.start
  RUBY
  @rspec_template = enable_code_coverage + rspec_template
end

Given(/^the rspec command "(.*?)"$/) do |rspec_command|
  @rspec_command = rspec_command
end

Given(/^the expectation:$/) do |expectation|
  rspec_template = ERB.new @rspec_template
  rspec_program = rspec_template.result(binding)
  step "a file named \"#{@rspec_file}\" with:", rspec_program
end

When(/^I run rspec$/) do
  step "I run `#{@rspec_command}`"
end

Then(/^the description should be "(.*?)"$/) do |description|
  step "the output should contain \"#{description}\""
end

Then(/^the failure message should be "(.*?)"$/) do |failure_message|
  step "the output should contain \"#{failure_message}\""
end

Then(/^the failure message should contain:$/) do |failure_message|
  step "the output should contain \"#{failure_message}\""
end
