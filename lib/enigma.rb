require './lib/shift'
require 'date'
require './lib/variable'
require './lib/offset'

class Enigma
  include Variable
  def initialize
    @chars = ('a'..'z').to_a << ' '
  end

  def line_breakdown(string)
    string.split('')
  end

  def get_shift(key, date)
    Shift.new(key, date).breakdown
  end

  def rotate_letter(move, char)
    location = @chars.index(char)
    if caller[4].include?('encrypt')
      @chars.rotate(move)[location]
    else
      @chars.rotate(-1 * move)[location]
    end
  end

  def shift_letter(char, round, key, date)
    if round <= 4
      move = get_shift(key, date).values[round - 1]
      rotate_letter(move, char)
    else
      move = get_shift(key, date).values[(round % 4) - 1]
      rotate_letter(move, char)
    end
  end

  def change_characters(string, key, date)
    round = 0
    line_breakdown(string).map do |char|
      if @chars.include?(char)
        round += 1
        shift_letter(char, round, key, date)
      else
        char = char
      end
    end.join
  end

  def encrypt(string, key = make_key, date = make_date)
    {
      encryption: change_characters(string.downcase, key, date),
      key: key,
      date: date
    }
  end

  def decrypt(string, key = make_key, date = make_date)
    {
      decryption: change_characters(string.downcase, key, date),
      key: key,
      date: date
    }
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

  def comparison_rotated_values(string)
    known_chars = [' ', 'e', 'n', 'd']
    known_chars.rotate(find_rotation(string)).zip(rotate_encoded_end(string))
  end

  def diff_values_hash(string)
    values = comparison_rotated_values(string).map do |pair|
      @chars.index(pair.first) - @chars.index(pair.last)
    end
    {
      A: values[0].to_i,
      B: values[1].to_i,
      C: values[2].to_i,
      D: values[3].to_i
    }
  end

  def key_hash(string, date)
    offset_hash = Offset.new(date).breakdown
    offset_hash.merge(diff_values_hash(string)) do |letter, offset, diff|
      ((-1 * diff) - offset)
    end
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

  def find_sequential_key(previous_value, diff)
    potential_keys(diff).select do |key|
      line_breakdown(key).first == line_breakdown(previous_value).last
    end.first
  end

  def find_new_key_value(previous_value, diff)
    if previous_value.nil?
      previous_value = nil
    elsif previous_value.split('').include?('n')
      previous_value = potential_keys(diff)[previous_value.split('').last.to_i]
    else
      previous_value = find_sequential_key(previous_value, diff)
    end
  end

  def test_key_hash(string, date, rnd)
    previous_value = 'n'.concat(rnd.to_s)
    key_hash(string, date).map do |letter, diff|
      previous_value = find_new_key_value(previous_value, diff)
      [letter, previous_value]
    end.to_h
  end

  def check_key_hash(string, date)
    rnd = 0
    while test_key_hash(string, date, rnd).values.any? {|value| value.nil? }
      rnd += 1
      test_key_hash(string, date, rnd)
    end
    test_key_hash(string, date, rnd)
  end

  def build_key(string, date)
    key = []
    check_key_hash(string, date).values.each_with_index do |value, index|
      if index == 0
        key << line_breakdown(value)
      else
        key << line_breakdown(value).last
      end
    end
    key.flatten.join
  end

  def crack(string, date = make_date)
    key = build_key(punctuation_remove(string), date)
    {
      decryption: change_characters(string.downcase, key, date),
      date: date,
      key: key
    }
  end
end
