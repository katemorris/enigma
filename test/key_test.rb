require 'minitest/autorun'
require 'minitest/pride'
require './lib/key.rb'

class KeyTest < Minitest::Test
  def test_it_exists
    key = Key.new

    assert_equal 5, key.value.to_s.length
  end
end
