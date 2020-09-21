require './test/test_helper'
require './lib/shift'

class ShiftTest < Minitest::Test
  def setup
    @shift = Shift.new
  end

  def test_it_exists
    assert_equal 5, @shift.key.value.length
    assert_equal 4, @shift.offset.value.length
  end

  def test_it_can_take_in_values
    shift = Shift.new('03782', '050585')
    assert_equal '03782', shift.key.value
    assert_equal '050585', shift.offset.date
  end

  def test_it_can_make_a_key_value
    assert_equal 5, @shift.make_key.length
  end

  def test_it_can_make_a_date_value
    Date.stubs(:today).returns(Date.new(2020,9,18))
    assert_equal '180920', @shift.make_date
  end

  def test_it_returns_shift_values
    @shift.key.stubs(:value).returns('19987')
    @shift.offset.stubs(:value).returns('0267')

    expected = { A: 19, B: 20, C: 23, D: 13 }
    assert_equal expected, @shift.breakdown
  end
end
