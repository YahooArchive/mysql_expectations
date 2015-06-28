# Copyright (c) 2015 Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.

module MySQLExpectations
  # An index field has a field name, length, and order (aka order)
  #
  class KeyField
    attr_reader :name, :length, :order

    ORDER_ASC = :asc
    ORDER_DESC = :desc

    VALID_ORDERINGS = [ORDER_ASC, ORDER_DESC]

    def initialize(name, order = nil, length = nil)
      @name = name
      @order = validate_order(order)
      @length = validate_length(length)
    end

    def ==(other)
      other.name == @name && other.length == @length && other.order == @order
    end

    def to_s
      "{ '#{name}', #{order_to_s}, #{length_to_s} }"
    end

    private

    def order_to_s
      return 'ASC' if order == ORDER_ASC
      return 'DESC' if order == ORDER_DESC
      'nil'
    end

    def length_to_s
      length.to_s unless length.nil?
      'nil'
    end

    def validate_length(length)
      return nil if length.nil?
      begin
        length = Integer(length)
      rescue ArgumentError
        raise ArgumentError, 'length must be an integer or convertable to an integer'
      end
      length
    end

    def validate_order(order)
      return nil if order.nil?
      return order if VALID_ORDERINGS.include? order
      fail ArgumentError, 'Order must be either KeyField::ORDER_ASC or KeyField::ORDER_DESC'
    end
  end
end
