require './test/test_helper'
require 'date'
require './lib/enigma'

class EnigmaTest < Minitest::Test
  def test_it_can_encrypt
    enigma = Enigma.new

    expected = {
                  encryption: "keder ohulw",
                  key: "02715",
                  date: "040895"
                }
    assert_equal expected, enigma.encrypt("hello world", "02715", "040895")
  end

end
