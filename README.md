ruby_solitaire
==============

Implementation of Bruce Schneier's [Solitaire pencil-and-paper cipher][1], featured on [Ruby Quiz][2].

[![Code Climate](https://codeclimate.com/github/erichs/ruby_solitaire_kata.png)](https://codeclimate.com/github/erichs/ruby_solitaire_kata)

Usage
=====

```ruby
require './solitaire'

s = Solitaire.new
puts s.cipher(:encrypt, 'DRINKYOUROVALTINE')         # => 'HOSLS XGAVV PNEBY IZPVH'

s = Solitaire.new()
puts s.cipher(:decrypt, 'HOSLS XGAVV PNEBY IZPVH')   # => 'DRINK YOURO VALTI NEXXX'

## Keyed with a passphrase
s = Solitaire.new
s.key! 'CRYPTONOMICON'
puts s.cipher(:encrypt, 'SOLITAIRE')                 # => 'KIRAK SFJAN'

s = Solitaire.new
s.key! 'CRYPTONOMICON'
puts s.cipher(:decrypt, 'KIRAK SFJAN')               # => 'SOLIT AIREX'
```

[1]: https://www.schneier.com/solitaire.html
[2]: http://rubyquiz.com/quiz1.html
