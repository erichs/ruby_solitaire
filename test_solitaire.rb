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

end

describe Solitaire do

  it "breaks a string into 5 character, padded blocks" do
    s = Solitaire.new( Deck.new )
    s.display_block("CODEINRUBYLIVELONGER").must_equal "CODEI NRUBY LIVEL ONGER"
    s.display_block("DRINKYOUROVALTINE").must_equal "DRINK YOURO VALTI NEXXX"
  end

  it "maps cards to numbers" do
    s = Solitaire.new( Deck.new )
    s.card_to_number("AC").must_equal (1 + 0) % 26
    s.card_to_number("2D").must_equal (2 + 13) % 26
    s.card_to_number("3H").must_equal (3 + 26) % 26
    s.card_to_number("4S").must_equal (4 + 39) % 26
    s.card_to_number("5C").must_equal (5 + 0) % 26
    s.card_to_number("6D").must_equal (6 + 13) % 26
    s.card_to_number("7H").must_equal (7 + 26) % 26
    s.card_to_number("8S").must_equal (8 + 39) % 26
    s.card_to_number("9C").must_equal (9 + 0) % 26
    s.card_to_number("10D").must_equal (10 + 13) % 26
    s.card_to_number("JH").must_equal (11 + 26) % 26
    s.card_to_number("QS").must_equal (12 + 39) % 26
    s.card_to_number("KC").must_equal (13 + 0) % 26
  end
end
