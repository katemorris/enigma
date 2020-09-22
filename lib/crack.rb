require './lib/enigma.rb'
enigma = Enigma.new

contents = open(ARGV.first).readlines
key = ''
date = ARGV.last
if contents.count > 1
  key = enigma.crack(contents.last.strip, date)[:key]
  decrypted_message = contents.map do |line|
    enigma.decrypt(line, key, date)[:decryption]
  end.join
else
  crack = enigma.crack(contents.first.strip, date)
  key = crack[:key]
  decrypted_message = crack[:decryption]
end
open(ARGV[1], 'w').write(decrypted_message)
puts "Created #{ARGV[1]} with the cracked key #{key} and date #{date}"
