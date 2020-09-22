require './lib/enigma.rb'
enigma = Enigma.new

encrypted = open(ARGV.first)
contents = encrypted.readlines
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
output = open(ARGV[1], 'w')
output.write(decrypted_message)
puts "Created #{ARGV[1]} with the cracked key #{key} and date #{date}"
encrypted.close
output.close
