module Variable
  def make_key
    5.times.map { rand(10) }.join.to_s
  end

  def make_date
    Date.today.strftime('%d%m%y')
  end

  def line_breakdown(string)
    string.split('')
  end

  def make_hash(values)
    list = {}
    list[:A] = values[0].to_i
    list[:B] = values[1].to_i
    list[:C] = values[2].to_i
    list[:D] = values[3].to_i
    list
  end
end
