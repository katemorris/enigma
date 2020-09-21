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

  def test_it_can_find_the_rotation_value_of_uncracked_code
    string = 'vjqtbeaweqihssi'
    assert_equal -3, @enigma.find_rotation(string)
    string2 = 'ksieufnjs huyeelskof'
    assert_equal 0, @enigma.find_rotation(string2)
    string3 = 'vjqtbeaweqi!hssi'
    assert_equal -3, @enigma.find_rotation(string3)
  end

  def test_it_can_rotate_the_encoded_end_to_align_with_message_length
    expected = ['s', 's', 'i', 'h']
    assert_equal expected, @enigma.rotate_encoded_end('vjqtbeaweqihssi')
  end

  def test_it_can_create_matched_pairs_of_encoded_decoded_end
    expected = [['e','s'], ['n', 's'], ['d', 'i'], [' ', 'h']]
    assert_equal expected, @enigma.comparison_rotated_values('vjqtbeaweqihssi')
  end

  def test_it_can_create_hash_using_difference_encoded_decoded_end
    expected = {
      A: -14,
      B: -5,
      C: -5,
      D: 19
    }
    assert_equal expected, @enigma.diff_values_hash('vjqtbeaweqihssi')
  end

  def test_it_can_create_key_hash
    values = { A: -14, B: -5, C: -5, D: 19 }
    @enigma.stubs(:diff_values_hash).returns(values)
    expected = {
      A: 8,
      B: 2,
      C: 3,
      D: -23
    }
    assert_equal expected, @enigma.key_hash('vjqtbeaweqihssi', '291018')
  end

  def test_it_can_generate_potential_keys_from_factors_of_27
    assert_equal ['08', '35', '62', '89', '116'], @enigma.potential_keys(8)
  end

  def test_it_can_select_next_key_from_potentials_matching_previous_key_char
    values = ['02', '29', '56', '83', '110']
    @enigma.stubs(:potential_keys).returns(values)
    assert_equal '56', @enigma.find_sequential_key('35', 2)
  end

  def test_it_can_return_next_value_if_first_nil_or_next_based_ob_prev_value
    values = ['08', '35', '62', '89', '116']
    @enigma.stubs(:potential_keys).returns(values)
    @enigma.stubs(:find_sequential_key).returns('56')

    assert_equal '56', @enigma.find_new_key_value('35', 2)
    assert_nil @enigma.find_new_key_value(nil, 2)
    assert_equal '62', @enigma.find_new_key_value('n2', 2)
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
    @enigma.stubs(:make_date).returns('180920')
    encrypted = {
      encryption: 'pib wdmczpu',
      key: '02715',
      date: '180920'
    }
    assert_equal encrypted, @enigma.encrypt('hello world', '02715')

    expected = {
      decryption: 'hello world',
      key: '02715',
      date: '180920'
    }
    assert_equal expected, @enigma.decrypt(encrypted[:encryption], '02715')
  end

  def test_it_can_encrypt_using_generated_variables
    @enigma.stubs(:make_date).returns('180920')
    @enigma.stubs(:make_key).returns('05732')
    expected = {
      encryption: 'sldqzgotbsw',
      key: '05732',
      date: '180920'
    }
    assert_equal expected, @enigma.encrypt('hello world')
  end

  def test_it_can_crack_a_code
    expected = {
      encryption: 'vjqtbeaweqihssi',
      key: '08304',
      date: '291018'
    }
    assert_equal expected, @enigma.encrypt("hello world end", "08304", "291018")

    cracked = {
      decryption: 'hello world end',
      date: '291018',
      key: '08304'
    }
    assert_equal cracked, @enigma.crack(expected[:encryption], expected[:date])
  end

  def test_it_can_crack_without_date
    @enigma.stubs(:make_date).returns('180920')
    cracked = {
      decryption: 'hello world end',
      date: '180920',
      key: '62862'
    }
    assert_equal cracked, @enigma.crack('vjqtbeaweqihssi')
  end

  def test_it_can_crack_a_code_with_punctuation
    skip
    expected = {
      encryption: 'vjqtbeaweqi!hssi.',
      key: '08304',
      date: '291018'
    }
    assert_equal expected, @enigma.encrypt("hello world! end", "08304", "291018")

    cracked = {
      decryption: 'hello world! end.',
      date: '291018',
      key: '08304'
    }
    assert_equal cracked, @enigma.crack(expected[:encryption], expected[:date])
  end
end
