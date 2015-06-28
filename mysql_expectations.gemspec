# Copyright (c) 2015 Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.

lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)
require_relative 'lib/mysql_expectations/version'

Gem::Specification.new do |s|
  s.name        = 'mysql_expectations'
  s.version     = MySQLExpectations::Version::VERSION
  s.license     = 'BSD-3-Clause'
  s.summary     = 'RSpec matchers for MySQL schemas and data'
  s.description = <<-EOF
    The mysql_expectations gem allows you to make RSpec expectations
    on the schemas and data in a MySQL database enabling test first
    development and more confident Continuous Delivery.
  EOF
  s.authors     = ['James Couball']
  s.email       = 'couballj@yahoo-inc.com'
  s.homepage    = 'https://github.com/yahoo/mysql_expectations'

  s.files       = Dir.glob('{bin,lib,data}/**/*')
  s.executables = Dir.glob('bin/**').map { |path| File.basename(path) }

  s.add_runtime_dependency 'rspec', '~> 3'

  s.add_development_dependency 'mustache', '~> 1'
  s.add_development_dependency 'rspec', '~> 3'
  s.add_development_dependency 'rspec-collection_matchers', '~> 1'
  s.add_development_dependency 'rubocop', '~> 0'
  s.add_development_dependency 'simplecov', '~> 0'
  s.add_development_dependency 'cucumber', '~> 1'
  s.add_development_dependency 'aruba', '~> 0'
  s.add_development_dependency 'relish', '~> 0'
  s.add_development_dependency 'rake', '~> 10.4'
  s.add_development_dependency 'codeclimate-test-reporter'
end
