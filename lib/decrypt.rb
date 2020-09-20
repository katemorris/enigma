require './lib/enigma.rb'
enigma = Enigma.new

contents = open(ARGV.first).readlines
key = ARGV[2]
date = ARGV.last
decrypted_message = contents.map do |line|
  array = enigma.decrypt(line, key, date)
  array[:decryption]
end
open(ARGV[1], 'w').write(decrypted_message.join)
puts "Created #{ARGV.last} with the key #{key} and date #{date}"
