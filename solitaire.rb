class JokerInOutput < Exception; end

class Solitaire
  attr_accessor :deck

  def initialize( deck, text="" )
    @text = text.gsub(' ', '').upcase
    @deck = deck
    @alphanum = Hash[("A".."Z").to_a.zip((1..26).to_a)]
    @numalpha = @alphanum.invert
  end

  def cipher( direction )
    cipher = ""
    @text.split(//).each do |letter|
      stream_number = generate_keystream_number!
      letter_number = letter_to_number letter

      if direction == :encrypt
        ciphered_number = (letter_number + stream_number) % 26
      else
        ciphered_number = (letter_number - stream_number) % 26
      end
      # adjust for Z=26, which has modulus of zero...
      ciphered_number = 26 if ciphered_number == 0

      cipher += number_to_letter ciphered_number
    end
    cipher
  end

  def display_block( text )
    chunks = text.scan(/.{1,5}/)
    chunks[-1] = chunks.last.ljust(5, "X")
    chunks.join " "
  end

  def card_to_number( card )
    name, suit = card.scan(/(.*)(.$)/).flatten
    return 53 if name == 'Joker'
    base_values = {'A'=>1, '2'=>2, '3'=>3, '4'=>4, '5'=>5, '6'=>6, '7'=>7, '8'=>8, '9'=>9, '10'=>10, 'J'=>11, 'Q'=>12, 'K'=>13}
    modifiers = {'C'=>0, 'D'=> 13, 'H'=>26, 'S'=>39}
    base_values[name] + modifiers[suit]
  end

  def letter_to_number( letter )
    letter = letter.upcase
    raise ArgumentError, :NotALetter unless ("A".."Z").include? letter
    @alphanum[letter]
  end

  def number_to_letter( number )
    raise ArgumentError, :NotAValidNumber unless (1..26).include? number
    @numalpha[number]
  end

  def find_output_card
    @deck.cards[card_to_number(@deck.cards.first)].tap do |card|
      raise JokerInOutput if !!card.match(/Joker/)
    end
  end

  def generate_keystream_number!
    @deck.move_down! "JokerA", 1
    @deck.move_down! "JokerB", 2
    @deck.triple_cut!
    @deck.count_cut! card_to_number(deck.cards.last)
    card_to_number(find_output_card)
  rescue JokerInOutput
    retry
  end
end

class Deck
  attr_accessor :cards

  def initialize( key_method = -> { Deck.unkeyed_positions } )
    @key_method = key_method
    @cards = key_method.call
  end

  def move_down!(card, offset)
    cardpos = @cards.index card
    @cards.delete_at(cardpos)

    newpos = cardpos + offset
    newpos > @cards.count && newpos = (offset % @cards.count) - 1

    @cards.insert(newpos, card)
  end

  def triple_cut!
    deck_size = @cards.count

    # positions of first and second jokers from top of deck
    first, second = [@cards.index("JokerA"), @cards.index("JokerB")].sort

    top_cut = @cards.shift first
    bottom_cut = @cards.pop deck_size - second - 1

    @cards = bottom_cut + @cards + top_cut
  end

  def count_cut!(number)
    cut = @cards.shift number
    @cards.insert(-2, *cut)
  end

  def self.unkeyed_positions
    cards = []
    names = ['A', ('2'..'10').to_a, 'J', 'Q', 'K'].flatten
    suits  = ['C', 'D', 'H', 'S']
    suits.each do |suit|
      cards << names.map { |name| name + suit }
    end
    cards = (cards + ['JokerA', 'JokerB']).flatten
  end

end
