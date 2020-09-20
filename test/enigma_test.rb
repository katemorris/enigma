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

  def test_it_can_rotate_characters_on_encrypt
    move = 4
    char = 't'
    String.any_instance.stubs(:include?).with('encrypt').returns(true)
    assert_equal 'x', @enigma.rotate_letter(move, char)
  end

  def test_it_can_rotate_characters_on_decrypt
    move = 4
    char = 't'
    assert_equal 'p', @enigma.rotate_letter(move, char)
  end

  def test_it_can_shift_letters
    char = 'r'
    round = 7
    key = '02715'
    date = '040895'
    @enigma.stubs(:rotate_letter).returns('j')
    assert_equal 'j', @enigma.shift_letter(char, round, key, date)
  end

  def test_it_can_encrypt_a_string
    string = 'hello world'
    string2 = 'hello world!'
    key = '02715'
    date = '040895'
    assert_equal 'keder ohulw', @enigma.change_characters(string, key, date)
    assert_equal 'keder ohulw!', @enigma.change_characters(string2, key, date)
  end

  def test_it_can_encrypt
    expected = {
                encryption: 'keder ohulw',
                key: '02715',
                date: '040895'
                }
    assert_equal expected, @enigma.encrypt('hello world', '02715', '040895')
  end

  def test_it_can_decrypt
    expected = {
                decryption: 'hello world',
                key: '02715',
                date: '040895'
                }
    assert_equal expected, @enigma.decrypt('keder ohulw', '02715', '040895')
  end

  def test_it_can_encrypt_and_decrypt_using_today_date
    @enigma.stubs(:make_date).returns('091820')
    encrypted = {
                encryption: 'lib sdmcvpu',
                key: '02715',
                date: '091820'
                }
    assert_equal encrypted, @enigma.encrypt('hello world', '02715')

    expected = {
                decryption: 'hello world',
                key: '02715',
                date: '091820'
                }
    assert_equal expected, @enigma.decrypt(encrypted[:encryption], '02715')
  end

  def test_it_can_encrypt_using_generated_variables
    @enigma.stubs(:make_date).returns('091820')
    @enigma.stubs(:make_key).returns('05732')
    expected = {
                encryption: 'oldqvgotysw',
                key: '05732',
                date: '091820'
                }
    assert_equal expected, @enigma.encrypt('hello world')
  end
end
