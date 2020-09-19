require './lib/key'
require './lib/offset'
class Shift
  attr_reader :key, :offset
  def initialize(key = nil, date = nil)
    key_check(key)
    offset_check(date)
  end

  def key_check(key)
    if key.nil?
      @key = Key.new
    else
      @key = Key.new(key)
    end
  end

  def offset_check(date)
    if date.nil?
      @offset = Offset.new
    else
      @offset = Offset.new(date)
    end
  end

  def breakdown
    @key.breakdown.merge(@offset.breakdown) do |letter, key_val, off_val|
      (key_val + off_val) % 27
    end
  end
end
