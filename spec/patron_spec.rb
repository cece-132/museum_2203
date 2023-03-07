require './lib/exhibit'
require './lib/patron'
require './lib/museum'
require 'pry'

RSpec.describe Patron do

  describe '#initialize' do
    it 'exists and has attributes' do
      @patron = Patron.new("Bob", 20)

      expect(@patron).to be_a(Patron)
      expect(@patron.name).to eq("Bob")
      expect(@patron.spending_money).to eq(20)
      expect(@patron.interests).to eq([])
    end
  end

  describe '#add_interests(interest)' do
    it 'can add an interest to the patrons interest array' do
      @patron = Patron.new("Bob", 20)

      @patron.add_interest("Dead Sea Scrolls")
      @patron.add_interest("Gems and Minerals")

      expect(@patron.interests).to eq(["Dead Sea Scrolls","Gems and Minerals"])
    end
  end

  describe '#spending_money' do
    before :each do
      @dmns = Museum.new("Denver Museum of Nature and Science")
      @gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
      @imax = Exhibit.new({name: "IMAX",cost: 15})
      @dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})

      @dmns.add_exhibit(@gems_and_minerals)
      @dmns.add_exhibit(@imax)
      @dmns.add_exhibit(@dead_sea_scrolls)
    end

    xit 'returns the amount of spending money that the patron has left' do
      @tj = Patron.new("TJ", 7)
      @tj.add_interest("IMAX")
      @tj.add_interest("Dead Sea Scrolls")
      @dmns.admit(@tj)

      expect(@tj.spending_money).to eq 7
    end

    xit 'only one exhibit is in the price range they attend that one' do
      @bob = Patron.new("Bob", 10)
      @bob.add_interest("Dead Sea Scrolls")
      @bob.add_interest("IMAX")
      @dmns.admit(@bob)
      expect(@bob.spending_money).to eq 0
    end
  end
end
