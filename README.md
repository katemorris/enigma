# Enigma
The most fun I have had in ages.

Example Interface
```
pry(main)> require 'date'
#=> true

pry(main)> require './lib/enigma'
#=> true

pry(main)> enigma = Enigma.new
#=> #<Enigma:0x00007ff90f24cb78...>

# encrypt a message with a key and date
pry(main)> enigma.encrypt("hello world", "02715", "040895")
#=>
#   {
#     encryption: "keder ohulw",
#     key: "02715",
#     date: "040895"
#   }

# decrypt a message with a key and date
pry(main) > enigma.decrypt("keder ohulw", "02715", "040895")
#=>
#   {
#     decryption: "hello world",
#     key: "02715",
#     date: "040895"
#   }

# encrypt a message with a key (uses today's date)
pry(main)> encrypted = enigma.encrypt("hello world", "02715")
#=> # encryption hash here

#decrypt a message with a key (uses today's date)
pry(main) > enigma.decrypt(encrypted[:encryption], "02715")
#=> # decryption hash here

# encrypt a message (generates random key and uses today's date)
pry(main)> enigma.encrypt("hello world")
#=> # encryption hash here

```
Command Line
```
$ ruby ./lib/encrypt.rb message.txt encrypted.txt
Created 'encrypted.txt' with the key 82648 and date 240818
$ ruby ./lib/decrypt.rb encrypted.txt decrypted.txt 82648 240818
Created 'decrypted.txt' with the key 82648 and date 240818
```
Cracking Interface
This was additional functionality that allowed for the cracking of a code without the key.
```
pry(main)> require 'date'
#=> true

pry(main)> require './lib/enigma'
#=> true

pry(main)> enigma = Enigma.new
#=> #<Enigma:0x00007ff90f24cb78...>

pry(main)> enigma.encrypt("hello world end", "08304", "291018")
#=>
#   {
#     encryption: "vjqtbeaweqihssi",
#     key: "08304",
#     date: "291018"
#   }

# crack an encryption with a date
pry(main)> enigma.crack("vjqtbeaweqihssi", "291018")
#=>
#   {
#     decryption: "hello world end",
#     date: "291018",
#     key: "08304"
#   }

# crack an encryption (uses today's date)
pry(main)> enigma.crack("vjqtbeaweqihssi")
#=>
#   {
#     decryption: "hello world end",
#     date: # todays date in the format DDMMYY,
#     key: # key used for encryption
#   }

```
Command Line Cracking
```
$ ruby ./lib/encrypt.rb message.txt encrypted.txt
Created 'encrypted.txt' with the key 82648 and date 240818
$ ruby ./lib/crack.rb encrypted.txt cracked.txt 240818
Created 'cracked.txt' with the cracked key 82648 and date 240818
```

## Functionality
**Proposed Grade: 4** - Above Expectations

All functionality is complete and tested with single line, multi-line, and those with various punctuation.

## Object Oriented Programming
**Proposed Grade: 4** - Above Expectations

There is one module and no inheritance. I didn't come across a good inheritance case in my setup. The modules were used across all classes to set or modify variables. They remove copied code and allow for a single place to modify, like in the case of my date formatting issue.

## Ruby Conventions and Mechanics
**Proposed Grade: 4** - Above Expectations

All code passes tests, almost all of HoundCI, and an A on Code Climate with no code smells. There is no usage of the single each enumerable in all classes and modules. Any questions about the usage of other enumerables is open to questioning of course.

Other enumerables used include: map, select, merge

## Test Driven Development
**Proposed Grade: 3.75** - Above Expectations

Test coverage is 100% according to SimpleCov, with mocks and stubs used to test individual method function. I was however, not that great at TDD at the end with cracking. I wrote almost all unit tests for that after the fact. :(

## Version Control
**Proposed Grade: 4** - Above Expectations

I have 120 commits and 10 branches at the writing of this document which will add another branch and about 5 commits. I might have misspelled now and then, but otherwise tried to be as clear as descriptive as possible.
