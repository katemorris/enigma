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
    -1 * (string.split('').length % 4)
  end

  def rotate_encoded_end(string)
    string.split('').pop(4).rotate(find_rotation(string))
  end

  def comparison_rotated_values(string)
    known_chars = [' ', 'e', 'n', 'd']
    known_chars.rotate(find_rotation(string)).zip(rotate_encoded_end(string))
  end

  def comparison_values(string)
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

  def offset_hash(date)
    Offset.new(date).breakdown
  end

  def key_hash(string, date)
    offset_hash(date).merge(comparison_values(string)) do |letter, offset, diff|
      ((-1 * diff) - offset)
    end
  end

  def decode_key(string, date)
    previous_value = '0'
    key_hash(string, date).map do |letter, key_shift_value|
      if previous_value == '0' && key_shift_value.to_s.length == 1
        previous_value = '0'.concat(key_shift_value.to_s)
      elsif previous_value == '0' && key_shift_value.to_s.length == 2
        previous_value = key_shift_value.to_s
      elsif key_shift_value.to_s.length == 1
        
      else

      end
    end
  end

  def find_key(string, date)
    require "pry"; binding.pry

  end

  def crack(string, date = make_date)
    key = find_key(string.downcase, date)
    {
      decryption: change_characters(string.downcase, date, key),
      date: date,
      key: key
    }
  end
end
