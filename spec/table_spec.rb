# Copyright (c) 2015 Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.

require_relative 'spec_helper'

describe Table do
  context 'a table with one field' do
    mysqldump_xml = <<-XML
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
              Index_comment="" Length="11"/>
          </table_structure>
        </database>
      </mysqldump>
    XML

    subject do
      MySQL.new(mysqldump_xml)
        .database('order_tracking')
        .table('item')
    end

    describe '#name' do
      it 'should have the expected name' do
        expect(subject.name).to eq('item')
      end
    end

    describe '#method_missing' do
      it { is_expected.to respond_to(:id) }
      it 'should return a field object' do
        expect(subject.id).to be_an_instance_of(Field)
      end
      it 'should raise an exception when called with args' do
        expect { subject.id(1) }.to raise_error NoMethodError
      end
      it 'should raise an exception when called with a block' do
        expect { subject.id {} }.to raise_error NoMethodError
      end
    end

    describe '#has_option?' do
      it { is_expected.to have_option('Version' => '10') }
    end

    describe '#collation' do
      it 'should have the expected collation' do
        expect(subject.collation).to eq('utf8_general_ci')
      end
    end

    describe '#has_collation?' do
      it { is_expected.to have_collation('utf8_general_ci') }
      it { is_expected.not_to have_collation('latin1') }
    end

    describe '#engine_type' do
      it 'shoud have the expected engine_type' do
        expect(subject.engine_type).to eq('InnoDB')
      end
    end

    describe '#has_engine_type?' do
      it { is_expected.to have_engine_type('InnoDB') }
      it { is_expected.not_to have_engine_type('MyISAM') }
    end

    describe '#has_field?' do
      it { is_expected.to have_field('id') }
      it { is_expected.not_to have_field('bogus') }
    end

    describe '#field' do
      it 'should return a MySQLStructure::Field object' do
        expect(subject.field 'id').to be_an_instance_of(
          Field
        )
      end
      it 'should return the named field if it exists' do
        expect(subject.field('id').name).to eq 'id'
      end
      it 'should return nil when the named field is not found' do
        expect(subject.field 'bogus').to be_nil
      end
    end

    describe '#fields' do
      it { is_expected.to have(1).fields }
    end
  end

  context 'a table with two fields' do
    mysqldump_xml = <<-XML
      <?xml version="1.0"?>
      <mysqldump xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <database name="order_tracking">
          <table_structure name="item">
            <field Field="id" Type="int(11)" Null="NO" Key="PRI"
              Extra="auto_increment" Comment="" />
            <field Field="name" Type="varchar(50)" Null="YES" Comment="" />
          </table_structure>
        </database>
      </mysqldump>
    XML

    subject do
      MySQL.new(mysqldump_xml)
        .database('order_tracking')
        .table('item')
    end

    describe '#fields' do
      it { is_expected.to have(2).fields }
    end

    describe '#field' do
      it "should have the fields 'id' and 'name' and nothing else" do
        is_expected.to have_field('id')
        is_expected.to have_field('name')
        is_expected.not_to have_field('bogus')
      end
    end
  end

  context 'a table without a primary key' do
    mysqldump_xml = <<-XML
      <?xml version="1.0"?>
      <mysqldump xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <database name="order_tracking">
          <table_structure name="invoice_items">
            <field
              Field="invoice_id" Type="int(11)" Null="NO" Key="PRI"
              Default="0" Extra="" Comment=""
            />
          </table_structure>
        </database>
      </mysqldump>
    XML

    subject do
      MySQL.new(mysqldump_xml)
        .database('order_tracking')
        .table('invoice_items')
    end

    describe '#primary_key' do
      it 'should not have a primary key' do
        expect(subject.primary_key?).to eq(false)
      end
    end
  end

  context 'a table with a multi-key primary index' do
    mysqldump_xml = <<-XML
      <?xml version="1.0"?>
      <mysqldump xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <database name="order_tracking">
          <table_structure name="invoice_items">
            <field
              Field="invoice_id" Type="int(11)" Null="NO" Key="PRI"
              Default="0" Extra="" Comment=""
            />
            <field
              Field="item_id" Type="int(11)" Null="NO" Key="PRI"
              Default="0" Extra="" Comment=""
            />
            <field
              Field="line" Type="int(11)" Null="NO" Key="PRI"
              Default="0" Extra="" Comment=""
            />
            <key
              Table="invoice_items" Non_unique="0" Key_name="PRIMARY"
              Seq_in_index="1" Column_name="invoice_id" Collation="A"
              Cardinality="0" Null="" Index_type="BTREE" Comment=""
              Index_comment=""
            />
            <key
              Table="invoice_items" Non_unique="0" Key_name="PRIMARY"
              Seq_in_index="2" Column_name="item_id" Collation="A"
              Cardinality="0" Null="" Index_type="BTREE" Comment=""
              Index_comment="" />
            <key
              Table="invoice_items" Non_unique="0" Key_name="PRIMARY"
              Seq_in_index="3" Column_name="line" Collation="A"
              Cardinality="0" Null="" Index_type="BTREE" Comment=""
              Index_comment="" />
            <key
              Table="invoice_items" Non_unique="0" Key_name="idx_invoice_id"
              Seq_in_index="1" Column_name="invoice_id" Collation="A"
              Cardinality="0" Null="" Index_type="BTREE" Comment=""
              Index_comment="" />
            <key
              Table="invoice_items" Non_unique="0" Key_name="idx_item_id"
              Seq_in_index="1" Column_name="item_id" Collation="A"
              Cardinality="0" Null="" Index_type="BTREE" Comment=""
              Index_comment="" />
            <key
              Table="invoice_items" Non_unique="0" Key_name="idx_line"
              Seq_in_index="1" Column_name="line" Collation="A"
              Cardinality="0" Null="" Index_type="BTREE" Comment=""
              Index_comment="" />
            <options
              Name="invoice_items" Engine="InnoDB" Version="10"
              Row_format="Compact" Rows="0" Avg_row_length="0"
              Data_length="16384" Max_data_length="0" Index_length="0"
              Data_free="0" Create_time="2015-04-28 02:39:55"
              Collation="latin1_swedish_ci" Create_options="" Comment="" />
          </table_structure>
        </database>
      </mysqldump>
    XML

    subject do
      MySQL.new(mysqldump_xml)
        .database('order_tracking')
        .table('invoice_items')
    end

    describe '#key?' do
      it 'should have a key named PRIMARY' do
        expect(subject.key?('PRIMARY')).to eq(true)
      end
      it 'should have a key named idx_invoice_id' do
        expect(subject.key?('idx_invoice_id')).to eq(true)
      end
      it 'should have a key named idx_item_id' do
        expect(subject.key?('idx_item_id')).to eq(true)
      end
      it 'should have a key named idx_line' do
        expect(subject.key?('idx_line')).to eq(true)
      end
      it 'should not have a key named bogus' do
        expect(subject.key?('bogus')).to eq(false)
      end
    end

    describe '#primary_key' do
      it 'should have a primary key' do
        expect(subject.primary_key?).to eq(true)
      end
    end

    describe '#key' do
      it 'should have a key named PRIMARY' do
        key = subject.key('PRIMARY')
        expect(key).not_to be_nil
        expect(key.name).to eq('PRIMARY')
      end
      it 'should not have a key named bogus' do
        expect(subject.key('bogus')).to be_nil
      end
    end

    describe '#keys' do
      it 'should have 4 keys' do
        expect(subject.keys.size).to eq(4)
      end
    end
  end
end
