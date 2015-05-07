# Copyright (c) 2015 Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.

Feature: only_have_tables matcher

  This matcher tests if a database only has the expected tables

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

  Scenario: only has tables
    Given the expectation:
      """ruby
      it { is_expected.to only_have_tables('order', 'item') }
      """
    When I run rspec
    Then the exit status should be 0
    And the description should be "only have tables 'order' and 'item'"

  Scenario: only has tables fails because of missing tables
    Given the expectation:
      """ruby
      # Note that the person table does not exist in the mysqldump
      #
      it { is_expected.to only_have_tables('order', 'item', 'person') }
      """
    When I run rspec
    Then the exit status should be 1
    And the description should be "only have tables 'order', 'item', and 'person'"
    And the failure message should be "expected 'order_tracking' database to only have tables 'order', 'item', and 'person' but was missing tables: 'person'"

  Scenario: only has tables fails because of additional tables
    Given the expectation:
      """ruby
      # Note that the item table also exists in the mysqldump
      #
      it { is_expected.to only_have_tables('order') }
      """
    When I run rspec
    Then the exit status should be 1
    And the description should be "only have tables 'order'"
    And the failure message should be "expected 'order_tracking' database to only have tables 'order' but had additional tables: 'item'"
