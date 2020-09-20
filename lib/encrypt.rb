require './lib/enigma.rb'
enigma = Enigma.new

contents = open(ARGV.first).readlines
key = ''
date = ''
encrypted_message = contents.map do |line|
  if date == '' && key == ''
    array = enigma.encrypt(line)
    date = array[:date]
    key = array[:key]
    array[:encryption]
  else
    enigma.encrypt(line, key, date)[:encryption]
  end
end
open(ARGV.last, 'w').write(encrypted_message.join)
puts "Created #{ARGV.last} with the key #{key} and date #{date}"
