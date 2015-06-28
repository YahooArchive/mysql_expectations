# Copyright (c) 2015 Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.

require_relative 'spec_helper'

describe KeyField do
  describe '#uniquess_to_s' do
    it 'should return nil when Key is initialized with nil uniqueness' do
      key = Key.new 'key_name', nil, []
      expect(key.uniqueness_to_s).to eq('nil')
    end
    it 'should return UNIQUE when Key is initialized with UNIQUE' do
      key = Key.new 'key_name', Key::UNIQUE, []
      expect(key.uniqueness_to_s).to eq('UNIQUE')
    end
    it 'should return NON_UNIQUE when Key is initialized with NON_UNIQUE' do
      key = Key.new 'key_name', Key::NON_UNIQUE, []
      expect(key.uniqueness_to_s).to eq('NON_UNIQUE')
    end
  end

  context 'initialized with just name' do
    subject { KeyField.new('id') }

    it "should have name 'id'" do
      expect(subject.name).to eq('id')
    end

    it 'should have length nil' do
      expect(subject.length).to be_nil
    end

    it 'should have order nil' do
      expect(subject.order).to be_nil
    end
  end

  context 'initialized with name and order' do
    subject { KeyField.new('id', KeyField::ORDER_ASC) }

    it 'should have the given name' do
      expect(subject.name).to eq('id')
    end

    it 'should have the given order' do
      expect(subject.order).to eq(KeyField::ORDER_ASC)
    end

    it 'should have length nil' do
      expect(subject.length).to be_nil
    end
  end

  context 'initialized with name, order, and length' do
    subject { KeyField.new('id', KeyField::ORDER_ASC, 40) }

    it 'should have the given name' do
      expect(subject.name).to eq('id')
    end

    it 'should have the given order' do
      expect(subject.order).to eq(KeyField::ORDER_ASC)
    end

    it 'should have length nil' do
      expect(subject.length).to eq(40)
    end

    describe '#==' do
      it 'should equal a different KeyField with the same values' do
        other = KeyField.new('id', KeyField::ORDER_ASC, 40)
        expect(subject == other).to eq(true)
      end
      it 'should not equal a different KeyField with different values' do
        other = KeyField.new('id', KeyField::ORDER_ASC, 38)
        expect(subject == other).to eq(false)
      end
    end
  end

  context 'initialized with a symbol other than '  \
    'KeyField::ORDER_ASC or KeyField::ORDER_DESC' do
    it 'should throw an exception during initialization' do
      expect do
        KeyField.new('id', :asdf)
      end.to raise_error ArgumentError
    end
  end

  context 'initialized with a length that is convertible to an integer' do
    it 'should not throw an error during initialization' do
      expect do
        KeyField.new('id', KeyField::ORDER_ASC, '40')
      end.not_to raise_error
    end
  end

  context 'initialized with a length that is NOT convertible to an integer' do
    it 'should not throw an error during initialization' do
      expect do
        KeyField.new('id', KeyField::ORDER_ASC, 'forty')
      end.to raise_error ArgumentError
    end
  end
end
