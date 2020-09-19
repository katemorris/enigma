require './test/test_helper'
require './lib/shift'

class ShiftTest < Minitest::Test
  def test_it_exists
    shift = Shift.new
    assert_equal 5, shift.key.value.length
    assert_equal 4, shift.offset.value.length
  end

  def test_it_can_take_in_values
    shift2 = Shift.new('03782', '050585')
    assert_equal '03782', shift2.key.value
    assert_equal '050585', shift2.offset.date
  end

  def test_key_returns_new_value_or_given
    shift = Shift.new

    assert_instance_of Key, shift.key_check(nil)
    assert_instance_of Key, shift.key_check('03782')
  end

  def test_it_returns_shift_values
    shift = Shift.new
    shift.key.stubs(:value).returns('19987')
    shift.offset.stubs(:value).returns('0267')

    expected = { A: 19, B: 20, C: 23, D: 13 }
    assert_equal expected, shift.breakdown
  end
end
