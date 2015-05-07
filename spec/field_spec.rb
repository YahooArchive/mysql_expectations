# Copyright (c) 2015 Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.

require_relative 'spec_helper'

describe Field do
  context "a field named 'id'" do
    mysqldump_xml = <<-XML
      <?xml version="1.0"?>
      <mysqldump xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <database name="order_tracking">
          <table_structure name="item">
            <field Field="id" Type="int(11)" Null="NO" Key="PRI"
              Extra="auto_increment" Comment="" />
            <field Field="first_name" Type="varchar(50)" Null="YES" Comment=""/>
          </table_structure>
        </database>
      </mysqldump>
    XML

    subject do
      MySQL.new(mysqldump_xml)
        .database('order_tracking')
        .table('item')
        .field('id')
    end

    describe '#has_definition?' do
      it { is_expected.to have_definition('Extra' => 'auto_increment') }
    end

    describe '#name' do
      it "should have name 'id'" do
        expect(subject.name).to eq('id')
      end
    end

    describe '#type' do
      it "should have the type 'int(11)'" do
        expect(subject.type).to eq('int(11)')
      end
    end

    describe '#has_type?' do
      it { is_expected.to have_type('int(11)') }
    end

    describe '#nullable?' do
      it { is_expected.not_to be_nullable }
    end
  end

  context "a field named 'first_name'" do
    mysqldump_xml = <<-XML
      <?xml version="1.0"?>
      <mysqldump xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <database name="order_tracking">
          <table_structure name="item">
            <field Field="id" Type="int(11)" Null="NO" Key="PRI"
              Extra="auto_increment" Comment="" />
            <field Field="first_name" Type="varchar(50)" Null="YES" Comment=""/>
          </table_structure>
        </database>
      </mysqldump>
    XML

    subject do
      MySQL.new(mysqldump_xml)
        .database('order_tracking')
        .table('item')
        .field('first_name')
    end

    describe '#nullable?' do
      it { is_expected.to be_nullable }
    end
  end
end
