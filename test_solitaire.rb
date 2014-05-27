require 'simplecov'
require 'turn/autorun'

SimpleCov.start do
  add_filter 'vendor'
end

require './solitaire'

describe Deck do

  it 'initializes the cards' do
    cards = Deck.new.cards
    cards.count.must_equal 54
    cards.include?('AC').must_equal true
    cards.include?('AD').must_equal true
    cards.include?('AH').must_equal true
    cards.include?('AS').must_equal true
  end

  it 'accepts a key method for deck randomization' do
    cards = Deck.new(-> { Deck.unkeyed_positions.reverse }).cards
    cards.first.must_equal 'JokerB'
  end

  it 'performs a cyclic downward move of a named card by 1' do
    deck = Deck.new(-> { %w(AC JokerA 3H 2D) })
    deck.move_down!('JokerA', 1)
    deck.cards.must_equal %w(AC 3H JokerA 2D)

    deck = Deck.new(-> { %w(AC 3H JokerA 2D) })
    deck.move_down!('JokerA', 1)
    deck.cards.must_equal %w(AC 3H 2D JokerA)
  end

  it 'performs a cyclic downward move of a named card by 2' do
    deck = Deck.new(-> { %w(AC JokerA 3H 2D 4S) })
    deck.move_down!('JokerA', 2)
    deck.cards.must_equal %w(AC 3H 2D JokerA 4S)

    deck = Deck.new(-> { %w(AC 3H JokerA 2D) })
    deck.move_down!('JokerA', 2)
    deck.cards.must_equal %w(AC JokerA 3H 2D)
  end

  it "performs a 'count cut': displacing N cards from the top to just above the bottom card" do
    deck = Deck.new(-> { %w(4C 3C AC 2C) })
    deck.count_cut!
    deck.cards.must_equal %w(AC 4C 3C 2C)
  end

  it "performs a 'triple cut' around the Jokers" do
    deck = Deck.new(-> { %w(7C 9H AC 4S KS AS JD JokerA 2H 2S QH 3S AD KD 7S 3H 9C 6C 3D QC 6H 8S JS 8D JH 10S KC 6S 4H 5C 2C 6D 5S 8C 10D 10H 4D AH 5D 9S 3C 7H 7D 4C JC 8H 2D KH 10C 9D JokerB 5H QD QS) })
    deck.triple_cut!
    deck.cards.must_equal %w(5H QD QS JokerA 2H 2S QH 3S AD KD 7S 3H 9C 6C 3D QC 6H 8S JS 8D JH 10S KC 6S 4H 5C 2C 6D 5S 8C 10D 10H 4D AH 5D 9S 3C 7H 7D 4C JC 8H 2D KH 10C 9D JokerB 7C 9H AC 4S KS AS JD)

    deck = Deck.new(-> { %w(JokerB 5H 8D 7S AC JokerA 3S 9S) })
    deck.triple_cut!
    deck.cards.must_equal %w(3S 9S JokerB 5H 8D 7S AC JokerA)

    deck = Deck.new(-> { %w(JokerB 5H 8D 7S AC JokerA) })
    deck.triple_cut!
    deck.cards.must_equal %w(JokerB 5H 8D 7S AC JokerA)
  end

  it 'maps cards to numbers' do
    deck = Deck.new
    deck.card_to_number('AC').must_equal (1 + 0)
    deck.card_to_number('2D').must_equal (2 + 13)
    deck.card_to_number('3H').must_equal (3 + 26)
    deck.card_to_number('4S').must_equal (4 + 39)
    deck.card_to_number('5C').must_equal (5 + 0)
    deck.card_to_number('6D').must_equal (6 + 13)
    deck.card_to_number('7H').must_equal (7 + 26)
    deck.card_to_number('8S').must_equal (8 + 39)
    deck.card_to_number('9C').must_equal (9 + 0)
    deck.card_to_number('10D').must_equal (10 + 13)
    deck.card_to_number('JH').must_equal (11 + 26)
    deck.card_to_number('QS').must_equal (12 + 39)
    deck.card_to_number('KC').must_equal (13 + 0)
    deck.card_to_number('JokerA').must_equal 53
    deck.card_to_number('JokerB').must_equal 53
  end

end

describe Solitaire do

  it 'keys a deck to a passphrase' do
    s = Solitaire.new
    s.key! 'CRYPTONOMICON'
    s.cipher(:encrypt, 'SOLITAIRE').must_equal 'KIRAK SFJAN'
  end

  it 'enciphers a plaintext' do
    s = Solitaire.new
    s.cipher(:encrypt, 'AAAAAAAAAA').must_equal 'EXKYI ZSGEH'
  end

  it 'deciphers a ciphertext' do
    s = Solitaire.new
    s.cipher(:decrypt, 'EXKYI ZSGEH').must_equal 'AAAAA AAAAA'
  end
end
