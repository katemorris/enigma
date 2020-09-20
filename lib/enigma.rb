require './lib/shift'
require 'date'
require './lib/variable'

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

  def comparison_hash(string)
    end_encoded = string.split('').pop(4) #hssi
    end_index = [' ', 'e', 'n', 'd']
    end_encoded.each_with_object({}) do |character, hash|
      end_index.each do |char_unencoded|
        hash[character] = char_unencoded
      end
    end
  end

  def find_key(string, date)
    round = 0
    comparison_hash(string).each_with_object({}) do |(encoded, decoded), hash|
      if encoded == decoded
        hash[:A] = 0
      else
        hash[:A] = @chars.index(encoded) - @chars.index(decoded)
      end
    end
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
