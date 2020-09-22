require './lib/enigma.rb'
enigma = Enigma.new

encrypted = open(ARGV.first)
contents = encrypted.readlines
key = ARGV[2]
date = ARGV.last
decrypted_message = contents.map do |line|
  enigma.decrypt(line, key, date)[:decryption]
end
decrypted = open(ARGV[1], 'w')
decrypted.write(decrypted_message.join)
puts "Created #{ARGV[1]} with the key #{key} and date #{date}"
encrypted.close
decrypted.close
