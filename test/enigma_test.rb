require './test/test_helper'
require 'date'
require './lib/enigma'

class EnigmaTest < Minitest::Test
  def setup
    @enigma = Enigma.new
  end

  def test_it_can_return_shift_breakdown
    expected = { A: 3, B: 0, C: 19, D: 20 }
    assert_equal expected, @enigma.get_shift('02715', '040895')
  end

  def test_it_can_shift_letters
    char = 'r'
    round = 7
    key = '02715'
    date = '040895'
    assert_equal 'j', @enigma.shift_letter(char, round, key, date)
  end

  def test_it_can_encrypt_a_string
    assert_equal 'keder ohulw', @enigma.encrypt_string('hello world', '02715', '040895')
  end

  def test_it_can_encrypt
    expected = {
                  encryption: 'keder ohulw',
                  key: '02715',
                  date: '040895'
                }
    assert_equal expected, @enigma.encrypt('hello world', '02715', '040895')
  end

end
