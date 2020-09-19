require 'date'

class Offset
  def value
    date = Date.today
    date_string = date.strftime('%m%d%Y')
    square_string = (date_string.to_i ** 2).to_s
    square_string.split('').last(4).join
  end
end
