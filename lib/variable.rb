module Variable
  def make_key
    5.times.map { rand(10) }.join.to_s
  end

  def make_date
    Date.today.strftime('%d%m%y')
  end

  def punctuation_remove(string)
    if @chars.include?(string.split('').last)
      string.downcase
    else
      string.downcase.delete(string.split('').last)
    end
  end
end
