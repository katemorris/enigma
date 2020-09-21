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
    make_hash(key_split)
  end
end
