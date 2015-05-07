# Copyright (c) 2015 Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.

require_relative 'spec_helper'

describe Key do
  context 'initialized with strings for key field' do
    subject { Key.new('key_name', Key::UNIQUE, ['id']) }
    it 'should have the given name' do
      expect(subject.name).to eq('key_name')
    end
    it 'should be unique' do
      expect(subject.unique).to eq(Key::UNIQUE)
    end
    it 'should have one key field' do
      expect(subject.fields.length).to eq(1)
    end
    it 'should have the expected key field' do
      key_field = subject.fields.first
      expect(key_field.name).to eq('id')
      expect(key_field.order).to be_nil
      expect(key_field.length).to be_nil
    end
    it 'should return the expected value from #to_s' do
      expect(subject.to_s).to eq("{ 'key_name', UNIQUE, [{ 'id', nil, nil }] }")
    end
  end

  context 'initialized with key field class' do
    subject do
      Key.new(
        'key_name',
        Key::NON_UNIQUE,
        [KeyField.new('id', KeyField::ORDER_ASC, 40)]
      )
    end
    it 'should have the expected key field' do
      key_field = subject.fields.first
      expect(key_field.name).to eq('id')
      expect(key_field.order).to eq(KeyField::ORDER_ASC)
      expect(key_field.length).to eq(40)
    end

    describe '#==' do
      it 'should equal a different Key with the same values' do
        other = Key.new(
          'key_name',
          Key::NON_UNIQUE,
          [KeyField.new('id', KeyField::ORDER_ASC, 40)]
        )
        expect(subject == other).to eq(true)
      end
      it 'should not equal a different Key with different values' do
        other = Key.new(
          'key_name',
          Key::NON_UNIQUE,
          [
            KeyField.new('id', KeyField::ORDER_ASC, 40),
            KeyField.new('sha', KeyField::ORDER_ASC, 40)
          ]
        )
        expect(subject == other).to eq(false)
      end
    end
  end
end
