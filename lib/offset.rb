require 'date'

class Offset
  def value
    date = Date.today
    date_string = date.strftime('%m%d%Y')
    square_string = (date_string.to_i ** 2).to_s
    square_string.split('').last(4).join
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
