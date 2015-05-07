# Copyright (c) 2015 Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.

Feature: have_key matcher

  This matcher tests if a table has the expected key.

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
            <key Table="item" Non_unique="1" Key_name="idx_item_description"
              Seq_in_index="1" Column_name="description" Collation="D"
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

  Scenario: table is expected to have key
    Given the expectation:
      """ruby
      expected_key = Key.new('PRIMARY', Key::UNIQUE, [KeyField.new('id', KeyField::ORDER_ASC, nil)])
      it { is_expected.to have_key(expected_key) }
      """
    When I run rspec
    Then the exit status should be 0
    And the description should be "should have key { 'PRIMARY', UNIQUE, [{ 'id', ASC, nil }] }"

  Scenario: table is not expected to have a key that does match an existing key
    Given the expectation:
      """ruby
      # Note the key field has a different ordering (DESC instead of ASC)
      #
      expected_key = Key.new('PRIMARY', Key::UNIQUE, [KeyField.new('id', KeyField::ORDER_DESC, nil)])
      it { is_expected.to have_key(expected_key) }
      """
    When I run rspec
    Then the exit status should be 1
    And the description should be "should have key { 'PRIMARY', UNIQUE, [{ 'id', DESC, nil }] }"
    And the failure message should contain:
      """
      expected 'item' table to have key { 'PRIMARY', UNIQUE, [{ 'id', DESC, nil }] } but it has keys:
             { 'PRIMARY', UNIQUE, [{ 'id', ASC, nil }] },
             { 'idx_item_description', NON_UNIQUE, [{ 'description', DESC, nil }] }
      """

  Scenario: table is expected to have key but there are no keys
    Given a file named "mysqldump.xml" with:
      """xml
      <?xml version="1.0"?>
      <mysqldump xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <database name="order_tracking">
          <table_structure name="item">
            <field Field="id" Type="int(11)" Null="NO" Comment="" />
            <field Field="description" Type="varchar(50)" Null="YES" Comment="" />
            <options Name="item" Engine="InnoDB" Version="10"
              Row_format="Dynamic" Rows="0" Avg_row_length="0"
              Data_length="16384" Max_data_length="0" Index_length="0"
              Data_free="0" Create_time="2015-03-20 23:17:12"
              Collation="utf8_general_ci" Create_options="" Comment=""/>
          </table_structure>
        </database>
      </mysqldump>
      """
    Given the expectation:
      """ruby
      expected_key = Key.new('PRIMARY', Key::UNIQUE, [KeyField.new('id', KeyField::ORDER_ASC, nil)])
      it { is_expected.to have_key(expected_key) }
      """
    When I run rspec
    Then the exit status should be 1
    And the description should be "should have key { 'PRIMARY', UNIQUE, [{ 'id', ASC, nil }] }"
    And the failure message should contain:
      """
      expected 'item' table to have key { 'PRIMARY', UNIQUE, [{ 'id', ASC, nil }] } but it has no keys
      """
