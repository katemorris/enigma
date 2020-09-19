require './lib/key.rb'
require './lib/offset.rb'
class Shift
  def initialize(key = nil, date = nil)
    @key = Key.new(key)
    @offset = Offset.new(date)
  end

  def method_name

  end
end
