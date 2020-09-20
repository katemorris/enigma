class Key
  attr_reader :value

  def initialize(key = 5.times.map { rand(10) }.join.to_s)
    @value = key
  end

  def breakdown
    key_split = self.value.split('')
    list = {}
    list[:A] = (key_split[0] + key_split[1]).to_i
    list[:B] = (key_split[1] + key_split[2]).to_i
    list[:C] = (key_split[2] + key_split[3]).to_i
    list[:D] = (key_split[3] + key_split[4]).to_i
    list
  end
end
