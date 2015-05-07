# Copyright (c) 2015 Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.

Feature: have_table matcher

  This matcher tests if a database has a table

  Background:
    Given a file named "mysqldump.xml" with:
      """xml
      <?xml version="1.0"?>
      <mysqldump xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <database name="order_tracking">
          <table_structure name="item">
            <field Field="id" Type="int(11)" Null="NO" Key="PRI"
              Extra="auto_increment" Comment="" />
          </table_structure>
          <table_structure name="order">
            <field Field="id" Type="int(11)" Null="NO" Key="PRI"
              Extra="auto_increment" Comment="" />
          </table_structure>
        </database>
      </mysqldump>
      """
    And the rspec template for "database_spec.rb":
      """ruby
      require 'mysql_expectations'

      include MySQLExpectations

      describe 'the order_tracking database' do
        let :databases do
          MySQL.new(File.new('mysqldump.xml'))
        end

        subject { databases.order_tracking }

        # Replace the following with your expectation(s):
        #
        <%= expectation %>
      end
      """
    And the rspec command "rspec ./database_spec.rb --format documentation"

  Scenario: expect database to have table
    Given the expectation:
      """ruby
      it { is_expected.to have_table('order') }
      """
    When I run rspec
    Then the exit status should be 0
    And the description should be "should have table 'order'"

  Scenario: expect database to have table but it does not
    Given the expectation:
      """ruby
      # Note that the person table does not exist in the mysqldump
      #
      it { is_expected.to have_table('person') }
      """
    When I run rspec
    Then the exit status should be 1
    And the description should be "should have table 'person'"
    And the failure message should be "expected 'order_tracking' database to have table 'person'"

  Scenario: expect database not to have table
    Given the expectation:
      """ruby
      it { is_expected.not_to have_table('person') }
      """
    When I run rspec
    Then the exit status should be 0
    And the description should be "should not have table 'person'"

  Scenario: expect database not to have table but it does
    Given the expectation:
      """ruby
      # Note that the order table exists in the mysqldump
      #
      it { is_expected.not_to have_table('order') }
      """
    When I run rspec
    Then the exit status should be 1
    And the description should be "should not have table 'order'"
    And the failure message should be "expected 'order_tracking' database not to have table 'order'"
