require './lib/shift'
require 'date'
require './lib/variable'
require './lib/offset'

class Enigma
  include Variable
  def initialize
    @chars = ('a'..'z').to_a << ' '
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

  def crack(string, date = make_date)
    key = CrackedKey.new(string, date).value
    {
      decryption: change_characters(string.downcase, key, date),
      date: date,
      key: key
    }
  end
end
