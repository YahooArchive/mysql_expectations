# Copyright (c) 2015 Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.

require_relative 'spec_helper'

describe MySQL do
  context 'a MySQL object with one database' do
    subject { MySQL.new(<<-XML) }
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

    describe '#method_missing' do
      it { is_expected.to respond_to(:order_tracking) }
      it 'should return a database object' do
        expect(subject.order_tracking).to be_an_instance_of(
          Database
        )
      end
      it 'should raise an exception when called with args' do
        expect { subject.order_tracking(1) }.to raise_error
      end
      it 'should raise an exception when called with a block' do
        expect { subject.order_tracking {} }.to raise_error
      end
    end

    describe '#has_database?' do
      it { is_expected.to have_database('order_tracking') }
      it { is_expected.not_to have_database('bogus') }
    end

    describe '#database' do
      it 'should return a MySQLStructure::Database object' do
        expect(subject.database 'order_tracking').to be_an_instance_of(
          Database
        )
      end
      it 'should return the named database if it exists' do
        expect(subject.database('order_tracking').name).to eq 'order_tracking'
      end
      it 'should return nil when the named database is not found' do
        expect(subject.database 'bogus').to be_nil
      end
    end
    describe '#databases' do
      it { is_expected.to have(1).databases }
    end
  end

  context 'a MySQL object with two databases' do
    mysqldump_xml = <<-XML
      <?xml version="1.0"?>
      <mysqldump xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <database name="order_tracking">
          <table_structure name="item">
            <field Field="id" Type="int(11)" Null="NO" Key="PRI"
              Extra="auto_increment" Comment="" />
          </table_structure>
        </database>
        <database name="employee">
          <table_structure name="contractor">
            <field Field="id" Type="int(11)" Null="NO" Key="PRI"
              Extra="auto_increment" Comment="" />
          </table_structure>
        </database>
      </mysqldump>
    XML

    subject { MySQL.new(mysqldump_xml) }

    describe '#databases' do
      it { is_expected.to have(2).databases }
    end
  end
end
