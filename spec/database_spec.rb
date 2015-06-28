# Copyright (c) 2015 Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.

require_relative 'spec_helper'

describe Database do
  context 'a database containing one table' do
    mysqldump_xml = <<-XML
      <?xml version="1.0"?>
      <mysqldump xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <database name="order_tracking">
          <table_structure name="item">
            <field Field="id" Type="int(11)" Null="NO" Key="PRI"
              Extra="auto_increment" Comment="" />
          </table_structure>
        </database>
      </mysqldump>
    XML

    subject do
      MySQL.new(mysqldump_xml)
        .database('order_tracking')
    end

    describe '#method_missing' do
      it { is_expected.to respond_to(:item) }
      it 'should return a table object' do
        expect(subject.item).to be_an_instance_of(Table)
      end
      it 'should raise an exception when called with args' do
        expect { subject.item(1) }.to raise_error NoMethodError
      end
      it 'should raise an exception when called with a block' do
        expect { subject.item {} }.to raise_error NoMethodError
      end
    end

    describe '#has_table?' do
      it { is_expected.to have_table('item') }
      it { is_expected.not_to have_table('bogus') }
    end

    describe '#table' do
      it 'should return a MySQL::Table object' do
        expect(subject.table 'item').to be_an_instance_of(Table)
      end
      it 'should return the named table if it exists' do
        expect(subject.table('item').name).to eq 'item'
      end
      it 'should return nil when the named table is not found' do
        expect(subject.table 'bogus').to be_nil
      end
    end
    describe '#tables' do
      it { is_expected.to have(1).tables }
    end
  end

  context 'a dump with two databases' do
    mysqldump_xml = <<-XML
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
    XML

    subject do
      MySQL.new(mysqldump_xml)
        .database('order_tracking')
    end

    describe '#tables' do
      it { is_expected.to have(2).tables }
    end
  end
end
