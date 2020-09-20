require './lib/key'
require './lib/offset'
class Shift
  attr_reader :key, :offset
  def initialize(key = make_key, date = make_date)
    @key = Key.new(key)
    @offset = Offset.new(date)
  end

  def make_key
    5.times.map { rand(10) }.join.to_s
  end

  def make_date
    Date.today.strftime('%m%d%Y')
  end

  def breakdown
    @key.breakdown.merge(@offset.breakdown) do |letter, key_val, off_val|
      (key_val + off_val) % 27
    end
  end
end
