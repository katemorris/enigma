require './test/test_helper'
require './lib/key.rb'

class KeyTest < Minitest::Test
  def test_it_exists
    key = Key.new

    assert_equal 5, key.value.length
  end

  def test_it_can_break_up_key_value
    key = Key.new('09907')

    expected = { A: 9, B: 99, C: 90, D: 7 }
    assert_equal expected, key.breakdown
  end
end
