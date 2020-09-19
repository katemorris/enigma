require 'date'

class Offset
  attr_reader :date
  def initialize(date = Date.today.strftime('%m%d%Y'))
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
