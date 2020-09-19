class Key
  attr_reader :value
  def initialize
    @value = 5.times.map { rand(10) }.join
  end
end
