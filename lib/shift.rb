require './lib/key'
require './lib/offset'
require './lib/variable'

class Shift
  attr_reader :key, :offset
  include Variable
  def initialize(key = make_key, date = make_date)
    @key = Key.new(key)
    @offset = Offset.new(date)
  end

  def breakdown
    @key.breakdown.merge(@offset.breakdown) do |letter, key_val, off_val|
      (key_val + off_val) % 27
    end
  end
end
