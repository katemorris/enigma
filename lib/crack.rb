require './lib/enigma.rb'
enigma = Enigma.new

contents = open(ARGV.first).readlines
key = ''
date = ARGV.last
if contents.count > 1
  key = enigma.crack(contents.last, date)[:key]
  decrypted_message = contents.map do |line|
    enigma.decrypt(line, key, date)[:decryption]
  end
else
  crack = enigma.crack(contents.first, date)[:key]
  key = crack[:key]
  decrypted_message = crack[:decryption]
end
open(ARGV[1], 'w').write(decrypted_message.join)
puts "Created #{ARGV[1]} with the cracked key #{key} and date #{date}"
