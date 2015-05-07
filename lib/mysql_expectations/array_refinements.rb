# Copyright (c) 2015 Yahoo Inc.
# Copyrights licensed under the New BSD License.
# See the accompanying LICENSE file for terms.

module MySQLExpectations
  # Monkey patch Array to have #to_sentence.
  # #to_sentence converts the array to a delimited string.
  # you pick the delimiter, you pick the coordinating
  # conjunction, you pick serial delimiter or not.
  #
  # Serial delimiter (or serial comma in the case the
  # delimiter is a comma), means to include the comma
  # between the last two items in the list.
  #
  module ArrayRefinements
    refine Array do
      def quote_elements(quote_with)
        map { |e| "#{quote_with}#{e}#{quote_with}" }
      end

      def delimited_conjunction(conjunction, delimiter, serial_delimiter)
        delimited_conjunction = conjunction
        delimited_conjunction += ' ' unless conjunction.empty?
        if serial_delimiter
          delimited_conjunction = delimiter + delimited_conjunction
        else
          delimited_conjunction = ' ' + delimited_conjunction
        end
        delimited_conjunction
      end

      def to_sentence(
        quote_with: "'", delimiter:  ', ', conjunction: 'and',
        serial_delimiter: true
      )
        return '' if self.empty?
        words = quote_elements(quote_with)
        return words[0] if words.size == 1
        return "#{words[0]} #{conjunction} #{words[1]}" if words.size == 2
        delimited_conjunction = delimited_conjunction(
          conjunction, delimiter, serial_delimiter)
        [words[0...-1].join(delimiter), words.last].join(delimited_conjunction)
      end
    end
  end
end
