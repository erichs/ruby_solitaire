require 'simplecov'
require 'turn/autorun'

SimpleCov.start do
  add_filter 'vendor'
end

require './solitaire'

describe Solitaire do

  it "initializes the deck" do
    deck = Solitaire.new.deck
    deck.count.must_equal 54
    deck.include?('AC').must_equal true
    deck.include?('AD').must_equal true
    deck.include?('AH').must_equal true
    deck.include?('AS').must_equal true
  end

  it "breaks a string into 5 character, padded blocks" do
    Solitaire.new.display_block("CODEINRUBYLIVELONGER").must_equal "CODEI NRUBY LIVEL ONGER"
    Solitaire.new.display_block("DRINKYOUROVALTINE").must_equal "DRINK YOURO VALTI NEXXX"
  end
end
