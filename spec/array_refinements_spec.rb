# Copyright (c) 2015 Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.

require_relative 'spec_helper'

using MySQLExpectations::ArrayRefinements

describe MySQLExpectations::ArrayRefinements do
  it 'correctly converts an empty array to an empty string' do
    a = []
    expect(a.to_sentence).to eq('')
  end
  it 'correctly converts a one element array to a string' do
    a = %w(first)
    expect(a.to_sentence).to eq("'first'")
  end
  it 'correctly converts a two element array to a string' do
    a = %w(first second)
    expect(a.to_sentence).to eq("'first' and 'second'")
  end
  it 'correctly converts a three element array to a string' do
    a = %w(first second third)
    expect(a.to_sentence).to eq("'first', 'second', and 'third'")
  end
  it 'lets you change the conjunction' do
    a = %w(first second third)
    expect(a.to_sentence(conjunction: 'or')).to eq("'first', 'second', or 'third'")
  end
  it 'lets you remove the conjunction' do
    a = %w(first second third)
    expect(a.to_sentence(conjunction: '')).to eq("'first', 'second', 'third'")
  end
  it 'lets you change the quote' do
    a = %w(first second third)
    expect(a.to_sentence(quote_with: '"')).to eq('"first", "second", and "third"')
  end
  it 'lets you omit the quotes' do
    a = %w(first second third)
    expect(a.to_sentence(quote_with: '')).to eq('first, second, and third')
  end
  it 'lets you change the delimiter' do
    a = %w(first second third)
    expect(a.to_sentence(delimiter: ',')).to eq("'first','second',and 'third'")
  end
  it 'lets you change the delimiter' do
    a = %w(first second third)
    expect(a.to_sentence(delimiter: ': ')).to eq("'first': 'second': and 'third'")
  end
  it 'lets you omit the last delimiter' do
    a = %w(first second third)
    expect(a.to_sentence(serial_delimiter: false)).to eq("'first', 'second' and 'third'")
  end
end
