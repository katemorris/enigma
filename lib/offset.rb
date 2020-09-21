require 'date'
require './lib/variable'
class Offset
  include Variable

  attr_reader :date

  def initialize(date = make_date)
    @date = date
  end

  def value
    (@date.to_i ** 2).to_s.split('').last(4).join
  end

  def breakdown
    key_split = value.split("")
    list = {}
    list[:A] = key_split[0].to_i
    list[:B] = key_split[1].to_i
    list[:C] = key_split[2].to_i
    list[:D] = key_split[3].to_i
    list
  end
end
