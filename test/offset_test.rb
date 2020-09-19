require './test/test_helper'
require './lib/offset.rb'
require 'mocha/minitest'

class OffsetTest < Minitest::Test
  def test_it_exists
    offset = Offset.new

    assert_equal 4, offset.value.length
  end

  def test_it_can_break_up_offset_value
    offset = Offset.new
    offset.stubs(:value).returns('0267')

    expected = { A: 0, B: 2, C: 6, D: 7 }
    assert_equal expected, offset.breakdown
  end
end
