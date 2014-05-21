class Solitaire
  attr_reader :deck

  def initialize
    @deck = initialize_deck
  end

  def display_block( text )
    chunks = text.scan /.{1,5}/
    chunks[-1] = chunks.last.ljust(5, "X")
    chunks.join " "
  end

  private
    def initialize_deck
      values = ['A', ('2'..'10').to_a, 'J', 'Q', 'K'].flatten
      suits  = ['C', 'D', 'H', 'S']
      deck = []
      suits.each do |suit|
        deck << values.map { |value| value + suit }
      end
      (deck + ['ZA', 'ZB']).flatten
    end
end
