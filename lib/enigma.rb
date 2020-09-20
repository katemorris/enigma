require './lib/shift'
class Enigma
  @@chars = ("a".."z").to_a << " "
  def line_breakdown(string)
    string.split('')
  end

  def get_shift(key, date)
    Shift.new(key, date).breakdown
  end

  def rotate(move, char)
    new = @@chars.index(char) + move
    if new > 26
      @@chars[new - 27]
    else
      @@chars[new]
    end
  end

  def shift_letter(char, round, key, date)
    if round <= 4
      move = get_shift(key, date).values[round - 1]
      rotate(move, char)
    else
      move = get_shift(key, date).values[(round % 4) - 1]
      rotate(move, char)
    end
  end

  def encrypt_string(string, key, date)
    round = 0
    line_breakdown(string).map do |char|
      if @@chars.include?(char)
        round += 1
        shift_letter(char, round, key, date)
      else
        char = char
      end
    end.join
  end

  def encrypt(string, key, date)
    {
      encryption: encrypt_string(string, key, date),
      key: key,
      date: date
    }
  end
end
