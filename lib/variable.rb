module Variable
  def make_key
    5.times.map { rand(10) }.join.to_s
  end

  def make_date
    Date.today.strftime('%m%d%y')
  end
end
