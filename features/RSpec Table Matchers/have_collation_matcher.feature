# Copyright (c) 2015 Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.

Feature: have_collation matcher

  This matcher tests if a table has the expected collation

  Background:
    Given a file named "mysqldump.xml" with:
      """xml
      <?xml version="1.0"?>
      <mysqldump xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <database name="order_tracking">
          <table_structure name="item">
            <field Field="id" Type="int(11)" Null="NO" Key="PRI"
              Extra="auto_increment" Comment="" />
            <options Name="item" Engine="InnoDB" Version="10"
              Row_format="Dynamic" Rows="0" Avg_row_length="0"
              Data_length="16384" Max_data_length="0" Index_length="0"
              Data_free="0" Create_time="2015-03-20 23:17:12"
              Collation="utf8_general_ci" Create_options="" Comment=""/>
            <key Table="item" Non_unique="0" Key_name="PRIMARY"
              Seq_in_index="1" Column_name="id" Collation="A"
              Cardinality="0" Null="" Index_type="BTREE" Comment=""
              Index_comment=""/>
          </table_structure>
        </database>
      </mysqldump>
      """
    And the rspec template for "table_spec.rb":
      """ruby
      require 'mysql_expectations'

      include MySQLExpectations

      describe 'database order_tracking' do
        let :databases do
          MySQL.new(File.new('mysqldump.xml'))
        end

        describe 'table item' do
          subject { databases.order_tracking.item }

          # Replace the following with your expectation(s):
          #
          <%= expectation %>
        end
      end
      """
    And the rspec command "rspec ./table_spec.rb --format documentation"

  Scenario: collation matches
    Given the expectation:
      """ruby
      it { is_expected.to have_collation('utf8_general_ci') }
      """
    When I run rspec
    Then the exit status should be 0
    And the description should be "should have collation 'utf8_general_ci'"

  Scenario: collation does not match
    Given the expectation:
      """ruby
      # Note that the collation is incorrect
      #
      it { is_expected.to have_collation('ascii_general_ci') }
      """
    When I run rspec
    Then the exit status should be 1
    And the description should be "should have collation 'ascii_general_ci'"
    And the failure message should be "expected 'item' table to have collation 'ascii_general_ci' but it was 'utf8_general_ci'"


