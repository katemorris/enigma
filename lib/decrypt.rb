require './lib/enigma.rb'
enigma = Enigma.new

contents = open(ARGV.first).readlines
key = ARGV[2]
date = ARGV.last
decrypted_message = contents.map do |line|
  enigma.decrypt(line, key, date)[:decryption]
end
open(ARGV[1], 'w').write(decrypted_message.join)
puts "Created #{ARGV[1]} with the key #{key} and date #{date}"
