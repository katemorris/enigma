require 'minitest/autorun'
require 'minitest/pride'
require './lib/offset.rb'

require 'mocha/minitest'

class OffsetTest < Minitest::Test
  def test_it_exists
    offset = Offset.new

    assert_equal 4, offset.value.length
  end
end
