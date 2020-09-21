require './test/test_helper'
require './lib/cracked_key'

class CrackedKeyTest < Minitest::Test
  def setup
    @cracked = CrackedKey.new('lwekuwdkgptcnmyo', '291018')
  end

  def test_it_can_crack_a_key
    assert_equal '08634', @cracked.value
  end

  def test_it_can_find_the_rotation_value_of_uncracked_code
    string = 'vjqtbeaweqihssi'
    assert_equal (-3), @cracked.find_rotation(string)
    string2 = 'ksieufnjs huyeelskof'
    assert_equal 0, @cracked.find_rotation(string2)
    string3 = 'vjqtbeaweqi!hssi'
    assert_equal (-3), @cracked.find_rotation(string3)
  end

  def test_it_can_rotate_the_encoded_end_to_align_with_message_length
    expected = ['s', 's', 'i', 'h']
    assert_equal expected, @cracked.rotate_encoded_end('vjqtbeaweqihssi')
  end

  def test_it_can_create_matched_pairs_of_encoded_decoded_end
    expected = [['e','s'], ['n', 's'], ['d', 'i'], [' ', 'h']]
    assert_equal expected, @cracked.comparison_rotated_values('vjqtbeaweqihssi')
  end

  def test_it_can_create_hash_using_difference_encoded_decoded_end
    expected = {
      A: -14,
      B: -5,
      C: -5,
      D: 19
    }
    assert_equal expected, @cracked.diff_values_hash('vjqtbeaweqihssi')
  end

  def test_it_can_create_key_hash
    values = { A: -14, B: -5, C: -5, D: 19 }
    @cracked.stubs(:diff_values_hash).returns(values)
    expected = {
      A: 8,
      B: 2,
      C: 3,
      D: -23
    }
    assert_equal expected, @cracked.key_hash('vjqtbeaweqihssi', '291018')
  end

  def test_it_can_generate_potential_keys_from_factors_of_27
    assert_equal ['08', '35', '62', '89', '116'], @cracked.potential_keys(8)
  end

  def test_it_can_select_next_key_from_potentials_matching_previous_key_char
    values = ['02', '29', '56', '83', '110']
    @cracked.stubs(:potential_keys).returns(values)
    assert_equal '56', @cracked.find_sequential_key('35', 2)
  end

  def test_it_can_return_next_value_if_first_nil_or_next_based_ob_prev_value
    values = ['08', '35', '62', '89', '116']
    @cracked.stubs(:potential_keys).returns(values)
    @cracked.stubs(:find_sequential_key).returns('56')

    assert_equal '56', @cracked.find_new_key_value('35', 2)
    assert_nil @cracked.find_new_key_value(nil, 2)
    assert_equal '62', @cracked.find_new_key_value('n2', 2)
  end

  def test_it_can_build_testable_key_hash
    values = { A: 8, B: 2, C: 3, D: -23 }
    @cracked.stubs(:key_hash).returns(values)
    @cracked.stubs(:find_new_key_value).returns('56')

    expected = { A: '56', B: '56', C: '56', D: '56' }
    assert_equal expected, @cracked.test_key_hash('mdksjiek', '080598', 2)
  end

  def test_it_can_check_for_valid_key_hash_or_redo
    @cracked.stubs(:any?).returns(false)
    values = { A: 35, B: 55, C: 59, D: 92 }
    @cracked.stubs(:test_key_hash).returns(values)
    assert_equal values, @cracked.check_key_hash('mdksjiek', '080598')
  end

  def test_it_can_build_key_value_from_hash
    values = { A: '62', B: '28', C: '86', D: '62' }
    @cracked.stubs(:check_key_hash).returns(values)
    assert_equal '62862', @cracked.build_key('mdksjiek', '080598')
  end
end
