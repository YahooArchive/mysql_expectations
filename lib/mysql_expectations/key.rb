# Copyright (c) 2015 Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.

require 'mysql_expectations/key_field'

module MySQLExpectations
  # An table key has a name and a sequence of index fields.
  #
  class Key
    attr_reader :name, :unique, :fields

    UNIQUE = true
    NON_UNIQUE = false

    def initialize(name, unique = nil, fields)
      @name = name
      @unique = unique
      @fields = []
      fields.each do |field|
        field = KeyField.new(field) unless field.instance_of?(KeyField)
        @fields << field
      end
    end

    def ==(other)
      name == other.name && unique == other.unique && fields == other.fields
    end

    def to_s
      result = "{ '#{name}', #{uniqueness_to_s}, ["
      fields.each_with_index do |field, index|
        result << ', ' if index > 0
        result << field.to_s
      end
      result << '] }'
      result
    end

    def uniqueness_to_s
      return 'nil' if unique.nil?
      return 'UNIQUE' if unique == true
      return 'NON_UNIQUE' if unique == false
    end

    def self.key?(table_element, key_name)
      result = table_element.elements["key[@Key_name='#{key_name}']"]
      !result.nil?
    end

    def self.load_key(table_element, key_name)
      if key?(table_element, key_name)
        key_fields = load_key_fields(table_element, key_name)
        unique = load_uniqueness(table_element, key_name)
        return Key.new(key_name, unique, key_fields)
      end
      nil
    end

    def self.load_all_keys(table_element)
      keys = {}
      table_element.elements.each('key') do |e|
        key_name = e.attributes['Key_name']
        unless keys.key? key_name
          keys[key_name] = load_key(table_element, key_name)
        end
      end
      keys.values
    end

    def self.find_key_element(table_element, index_name, field_index)
      query = "key[@Key_name='#{index_name}' and " \
        "@Seq_in_index='#{field_index + 1}']"
      table_element.elements[query]
    end

    def self.collation_from_s(collation)
      return KeyField::ORDER_DESC if collation == 'D'
      KeyField::ORDER_ASC
    end

    def self.load_key_field(key_element)
      name = key_element.attributes['Column_name']
      collation = key_element.attributes['Collation']
      collation = collation_from_s(collation)
      length = key_element.attributes['Length']
      KeyField.new(name, collation, length)
    end

    def self.load_uniqueness(table_element, key_name)
      key_element = find_key_element(table_element, key_name, 0)
      return nil if key_element.nil?
      (key_element.attributes['Non_unique'] == '0')
    end

    def self.load_key_fields(table_element, key_name)
      key_fields = []
      (0..1000).each do |field_index|
        key_element = find_key_element(table_element, key_name, field_index)
        break if key_element.nil?
        key_fields << load_key_field(key_element)
      end
      key_fields
    end
  end
end
