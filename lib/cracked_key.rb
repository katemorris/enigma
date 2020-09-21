require './lib/offset'
require './lib/variable'

class CrackedKey
  include Variable
  attr_reader :value
  def initialize(string, date)
    @chars = ('a'..'z').to_a << ' '
    @value = crack(string, date)
  end

  def crack(string, date)
    build_key(punctuation_remove(string), date)
  end

  def punctuation_remove(string)
    if @chars.include?(string.split('').last)
      string.downcase
    else
      string.downcase.delete(string.split('').last)
    end
  end

  def build_key(string, date)
    key = []
    check_key_hash(string, date).values.each_with_index do |value, index|
      if index.zero?
        key << line_breakdown(value)
      else
        key << line_breakdown(value).last
      end
    end
    key.flatten.join
  end

  def check_key_hash(string, date)
    rnd = 0
    while test_key_hash(string, date, rnd).values.any? { |value| value.nil? }
      rnd += 1
      test_key_hash(string, date, rnd)
    end
    test_key_hash(string, date, rnd)
  end

  def test_key_hash(string, date, rnd)
    previous_value = 'n'.concat(rnd.to_s)
    key_hash(string, date).map do |letter, diff|
      previous_value = find_new_key_value(previous_value, diff)
      [letter, previous_value]
    end.to_h
  end

  def key_hash(string, date)
    offset_hash = Offset.new(date).breakdown
    offset_hash.merge(diff_values_hash(string)) do |_letter, offset, diff|
      ((-1 * diff) - offset)
    end
  end

  def find_new_key_value(previous_value, diff)
    if previous_value.nil?
      nil
    elsif previous_value.split('').include?('n')
      potential_keys(diff)[previous_value.split('').last.to_i]
    else
      find_sequential_key(previous_value, diff)
    end
  end

  def find_sequential_key(previous_value, diff)
    potential_keys(diff).select do |key|
      line_breakdown(key).first == line_breakdown(previous_value).last
    end.first
  end

  def potential_keys(diff)
    [0, 1, 2, 3, 4].map do |value|
      potential = ((27 * value) + diff.to_i).to_s
      if potential.length == 1
        '0'.concat(potential)
      else
        potential
      end
    end
  end

  def diff_values_hash(string)
    values = comparison_rotated_values(string).map do |pair|
      @chars.index(pair.first) - @chars.index(pair.last)
    end
    make_hash(values)
  end

  def comparison_rotated_values(string)
    known_chars = [' ', 'e', 'n', 'd']
    known_chars.rotate(find_rotation(string)).zip(rotate_encoded_end(string))
  end

  def find_rotation(string)
    included_set = string.split('').select do |char|
      @chars.include?(char)
    end
    -1 * (included_set.length % 4)
  end

  def rotate_encoded_end(string)
    string.split('').pop(4).rotate(find_rotation(string))
  end
end
