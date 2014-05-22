class Solitaire
  attr_reader :deck

  def initialize( deck )
    @deck = deck
  end

  def display_block( text )
    chunks = text.scan /.{1,5}/
    chunks[-1] = chunks.last.ljust(5, "X")
    chunks.join " "
  end

  def card_to_number( card )
    name, suit = card.scan(/(.*)(.$)/).flatten
    return 53 if name == 'Joker'
    base_values = {'A'=>1, '2'=>2, '3'=>3, '4'=>4, '5'=>5, '6'=>6, '7'=>7, '8'=>8, '9'=>9, '10'=>10, 'J'=>11, 'Q'=>12, 'K'=>13}
    modifiers = {'C'=>0, 'D'=> 13, 'H'=>26, 'S'=>39}
    base_values[name] + modifiers[suit] % 26
  end
end

class Deck
  attr_accessor :cards

  def initialize( key_method = -> { Deck.unkeyed_positions } )
    @key_method = key_method
    @cards = key_method.call
  end

  require 'debugger'
  def move_down!(card, offset)
    cardpos = @cards.index card
    @cards.delete_at(cardpos)

    newpos = cardpos + offset
    if newpos > @cards.count
      newpos = (offset % @cards.count) - 1
    end

    @cards.insert(newpos, card)
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
