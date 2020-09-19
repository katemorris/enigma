require 'minitest/autorun'
require 'minitest/pride'
require './lib/key.rb'
require 'mocha/minitest'

class KeyTest < Minitest::Test
  def test_it_exists
    key = Key.new

    assert_equal 5, key.value.to_s.length
  end

  def test_it_can_break_up_key_value
    key = Key.new
    key.stubs(:value).returns(19987)

    expected = { A: 19, B: 99, C: 98, D: 87 }
    assert_equal expected, key.breakdown
  end
end
