require 'simplecov'
require 'turn/autorun'

SimpleCov.start do
  add_filter 'vendor'
end

require './solitaire'

describe Deck do

  it "initializes the cards" do
    cards = Deck.new.cards
    cards.count.must_equal 54
    cards.include?('AC').must_equal true
    cards.include?('AD').must_equal true
    cards.include?('AH').must_equal true
    cards.include?('AS').must_equal true
  end

  it "accepts a key method for deck randomization" do
    cards = Deck.new(-> { Deck.unkeyed_positions.reverse }).cards
    cards.first.must_equal "JokerB"
  end

  it "performs a cyclic downward move of a named card by 1" do
    deck = Solitaire.new(Deck.new(->{ [ "AC", "JokerA", "3H", "2D" ] })).deck
    deck.move_down!("JokerA", 1)
    deck.cards.must_equal [ "AC", "3H", "JokerA", "2D" ]

    deck = Solitaire.new(Deck.new(->{ [ "AC", "3H", "JokerA", "2D" ] })).deck
    deck.move_down!("JokerA", 1)
    deck.cards.must_equal [ "AC", "3H", "2D", "JokerA" ]
  end

  it "performs a cyclic downward move of a named card by 2" do
    deck = Solitaire.new(Deck.new(->{ [ "AC", "JokerA", "3H", "2D", "4S" ] })).deck
    deck.move_down!("JokerA", 2)
    deck.cards.must_equal [ "AC", "3H", "2D", "JokerA", "4S" ]

    deck = Solitaire.new(Deck.new(->{ [ "AC", "3H", "JokerA", "2D" ] })).deck
    deck.move_down!("JokerA", 2)
    deck.cards.must_equal [ "AC", "JokerA", "3H", "2D" ]
  end

  it "performs a 'count cut': displacing N cards from the top to just above the bottom card" do
    s = Solitaire.new Deck.new(->{ [ "4C", "3C", "AC", "2C" ] })
    deck = s.deck
    deck.count_cut! s.card_to_number(deck.cards.last)
    deck.cards.must_equal [ "AC", "4C", "3C", "2C" ]
  end

  it "performs a 'triple cut' around the Jokers" do
    deck = Deck.new(->{["7C", "9H", "AC", "4S", "KS", "AS", "JD", "JokerA", "2H", "2S", "QH", "3S", "AD", "KD", "7S", "3H", "9C", "6C", "3D", "QC", "6H", "8S", "JS", "8D", "JH", "10S", "KC", "6S", "4H", "5C", "2C", "6D", "5S", "8C", "10D", "10H", "4D", "AH", "5D", "9S", "3C", "7H", "7D", "4C", "JC", "8H", "2D", "KH", "10C", "9D", "JokerB", "5H", "QD", "QS"]})
    deck.triple_cut!
    deck.cards.must_equal ["5H", "QD", "QS", "JokerA", "2H", "2S", "QH", "3S", "AD", "KD", "7S", "3H", "9C", "6C", "3D", "QC", "6H", "8S", "JS", "8D", "JH", "10S", "KC", "6S", "4H", "5C", "2C", "6D", "5S", "8C", "10D", "10H", "4D", "AH", "5D", "9S", "3C", "7H", "7D", "4C", "JC", "8H", "2D", "KH", "10C", "9D", "JokerB", "7C", "9H", "AC", "4S", "KS", "AS", "JD"]

    deck = Deck.new(->{["JokerB", "5H", "8D", "7S", "AC", "JokerA", "3S", "9S"]})
    deck.triple_cut!
    deck.cards.must_equal ["3S", "9S", "JokerB", "5H", "8D", "7S", "AC", "JokerA"]

    deck = Deck.new(->{["JokerB", "5H", "8D", "7S", "AC", "JokerA"]})
    deck.triple_cut!
    deck.cards.must_equal ["JokerB", "5H", "8D", "7S", "AC", "JokerA"]
  end
end

describe Solitaire do

  it "converts letters to numbers" do
    s = Solitaire.new( Deck.new )
    s.letter_to_number("A").must_equal 1
    s.letter_to_number("Z").must_equal 26
    proc{s.letter_to_number(":")}.must_raise ArgumentError, :NotALetter
  end

  it "converts numbers to letters" do
    s = Solitaire.new( Deck.new )
    s.number_to_letter(1).must_equal "A"
    s.number_to_letter(26).must_equal "Z"
    proc{s.number_to_letter(27)}.must_raise ArgumentError, :NotAValidNumber
  end

  it "breaks a string into 5 character, padded blocks" do
    s = Solitaire.new( Deck.new )
    s.display_block("CODEINRUBYLIVELONGER").must_equal "CODEI NRUBY LIVEL ONGER"
    s.display_block("DRINKYOUROVALTINE").must_equal "DRINK YOURO VALTI NEXXX"
  end

  it "maps cards to numbers" do
    s = Solitaire.new( Deck.new )
    s.card_to_number("AC").must_equal (1 + 0)
    s.card_to_number("2D").must_equal (2 + 13)
    s.card_to_number("3H").must_equal (3 + 26)
    s.card_to_number("4S").must_equal (4 + 39)
    s.card_to_number("5C").must_equal (5 + 0)
    s.card_to_number("6D").must_equal (6 + 13)
    s.card_to_number("7H").must_equal (7 + 26)
    s.card_to_number("8S").must_equal (8 + 39)
    s.card_to_number("9C").must_equal (9 + 0)
    s.card_to_number("10D").must_equal (10 + 13)
    s.card_to_number("JH").must_equal (11 + 26)
    s.card_to_number("QS").must_equal (12 + 39)
    s.card_to_number("KC").must_equal (13 + 0)
    s.card_to_number("JokerA").must_equal 53
    s.card_to_number("JokerB").must_equal 53
  end

  it "finds an output card" do
    s = Solitaire.new( Deck.new(->{["AC", "2D", "3H"]}) )
    s.find_output_card.must_equal "2D"

    s = Solitaire.new( Deck.new(->{["2C", "2D", "JokerA", "3H"]}) )
    proc{s.find_output_card}.must_raise JokerInOutput
  end

  it "generates a keystream number" do
    s = Solitaire.new( Deck.new )
    s.generate_keystream_number!.must_equal 4
    s.generate_keystream_number!.must_equal 49
    s.generate_keystream_number!.must_equal 10
    s.generate_keystream_number!.must_equal 24
    s.generate_keystream_number!.must_equal 8
    s.generate_keystream_number!.must_equal 51
    s.generate_keystream_number!.must_equal 44
    s.generate_keystream_number!.must_equal 6
    s.generate_keystream_number!.must_equal 4
    s.generate_keystream_number!.must_equal 33
  end
end
