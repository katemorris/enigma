require './test/test_helper'
require './lib/key.rb'
require './lib/offset.rb'
require './lib/shift.rb'

class ShiftTest < Minitest::Test
  def test_it_exists
    shift = Shift.new
    assert_instance_of Shift, shift
    assert_includes 5, shift.key.value.length
    assert_includes 4, shift.offset.value.length
  end

  def test_it_has_complete_shift_values
    shift = Shift.new

  end
end
