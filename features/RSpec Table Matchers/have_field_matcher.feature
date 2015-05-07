# Copyright (c) 2015 Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.

Feature: have_field matcher

  This matcher tests if a table has the expected field.
  It also optionally tests that the field is of the right type and nullability.

  Background:
    Given a file named "mysqldump.xml" with:
      """xml
      <?xml version="1.0"?>
      <mysqldump xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <database name="order_tracking">
          <table_structure name="item">
            <field Field="id" Type="int(11)" Null="NO" Key="PRI"
              Extra="auto_increment" Comment="" />
            <field Field="description" Type="varchar(50)" Null="YES" Comment="" />
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

  Scenario: table is expected to have field
    Given the expectation:
      """ruby
      it { is_expected.to have_field('id') }
      """
    When I run rspec
    Then the exit status should be 0
    And the description should be "should have field 'id'"

  Scenario: table is expected to have field that does not exist
    Given the expectation:
      """ruby
      # Note that the item table does not have the field bogus
      #
      it { is_expected.to have_field('bogus') }
      """
    When I run rspec
    Then the exit status should be 1
    And the description should be "should have field 'bogus'"
    And the failure message should be "expected 'item' table to have field 'bogus'"

  Scenario: table is expected not to have field
    Given the expectation:
      """ruby
      # Note that the item table does not have the field bogus
      #
      it { is_expected.not_to have_field('bogus') }
      """
    When I run rspec
    Then the exit status should be 0
    And the description should be "should not have field 'bogus'"

  Scenario: table is expected not to have field but does
    Given the expectation:
      """ruby
      # Note that the item table does have the field id
      #
      it { is_expected.not_to have_field('id') }
      """
    When I run rspec
    Then the exit status should be 1
    And the description should be "should not have field 'id'"
    And the failure message should be "expected 'item' table not to have field 'id'"

  Scenario: table is expected to have field of a certain type
    Given the expectation:
      """ruby
      it { is_expected.to have_field('id').of_type('int(11)') }
      """
    When I run rspec
    Then the exit status should be 0
    And the description should be "should have field 'id' of type 'int(11)'"

  Scenario: table is expected to have field of a certain type but type is wrong
    Given the expectation:
      """ruby
      # Note that the item table does have the field id but it type is not char(40)
      #
      it { is_expected.to have_field('id').of_type('char(40)') }
      """
    When I run rspec
    Then the exit status should be 1
    And the description should be "should have field 'id' of type 'char(40)'"
    And the failure message should be "expected 'item.id' field to be of type 'char(40)' but it was 'int(11)'"

  Scenario: table is expected to have field of a certain type that is nullable
    Given the expectation:
      """ruby
      it { is_expected.to have_field('description').of_type('varchar(50)').that_is_nullable }
      """
    When I run rspec
    Then the exit status should be 0
    And the description should be "should have field 'description' of type 'varchar(50)' that is nullable"

  Scenario: table is expected to have a field that is nullable but it is not nullable
    Given the expectation:
      """ruby
      # Note that the item table does have the field id but it is not nullable
      #
      it { is_expected.to have_field('id').that_is_nullable }
      """
    When I run rspec
    Then the exit status should be 1
    And the description should be "should have field 'id' that is nullable"
    And the failure message should be "expected 'item.id' field to be nullable but it was not nullable"

  Scenario: table is expected to have field of a certain type that is not nullable
    Given the expectation:
      """ruby
      it { is_expected.to have_field('id').of_type('int(11)').that_is_not_nullable }
      """
    When I run rspec
    Then the exit status should be 0
    And the description should be "should have field 'id' of type 'int(11)' that is not nullable"


  Scenario: table is expected to have field that is not nullable but it was nullable
    Given the expectation:
      """ruby
      # Note that the item table does have the field id but its type is not char(40)
      #
      it { is_expected.to have_field('description').that_is_not_nullable }
      """
    When I run rspec
    Then the exit status should be 1
    And the description should be "should have field 'description' that is not nullable"
    And the failure message should be "expected 'item.description' field to be not nullable but it was nullable"



