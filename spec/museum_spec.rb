require './lib/museum'
require './lib/patron'
require './lib/exhibit'
require 'pry'

RSpec.describe Museum do
  before :each do
    @dmns = Museum.new("Denver Museum of Nature and Science")
  end

  describe '#initialize' do
    it 'exists and has attributes' do
      expect(@dmns).to be_a(Museum)
      expect(@dmns.name).to eq("Denver Museum of Nature and Science")
      expect(@dmns.exhibits).to be_empty
      expect(@dmns.exhibits).to be_a Array
      expect(@dmns.patrons).to be_empty
      expect(@dmns.exhibits).to be_a Array
    end
  end

  describe '#add_exhibit(exhibit)' do
    it 'can add exhibits' do
      gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
      dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
      imax = Exhibit.new({name: "IMAX",cost: 15})

      @dmns.add_exhibit(gems_and_minerals)
      @dmns.add_exhibit(dead_sea_scrolls)
      @dmns.add_exhibit(imax)
      expect(@dmns.exhibits).to eq([gems_and_minerals, dead_sea_scrolls, imax])
    end
  end

  describe '#admit(patron)' do
    before :each do
      @gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
      @dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
      @imax = Exhibit.new({name: "IMAX",cost: 15})

      @patron_1 = Patron.new("Bob", 0)
      @patron_2 = Patron.new("Sally", 20)
      @patron_3 = Patron.new("Johnny", 5)
    end

    it 'can add patrons to patron array' do
      @dmns.admit(@patron_1)
      @dmns.admit(@patron_2)
      @dmns.admit(@patron_3)

      expect(@dmns.patrons).to eq([@patron_1, @patron_2, @patron_3])
    end
  end

  describe '#add_exhibits' do
    before :each do
      @gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
      @dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
      @imax = Exhibit.new({name: "IMAX",cost: 15})
    end

    it 'can add exhibits to the museum' do
      @dmns.add_exhibit(@gems_and_minerals)
      @dmns.add_exhibit(@dead_sea_scrolls)
      @dmns.add_exhibit(@imax)

      expect(@dmns.exhibits).to eq([@gems_and_minerals, @dead_sea_scrolls, @imax])
    end
  end

  describe '#recommend_exhibits(patron)' do
    it 'can sort exhibits by patron interests' do
      @gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
      @dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
      @imax = Exhibit.new({name: "IMAX",cost: 15})

      @dmns.add_exhibit(@gems_and_minerals)
      @dmns.add_exhibit(@dead_sea_scrolls)
      @dmns.add_exhibit(@imax)

      @patron_1 = Patron.new("Bob", 20)

      @patron_1.add_interest("Dead Sea Scrolls")      
      @patron_1.add_interest("Gems and Minerals")

      expect(@dmns.recommend_exhibits(@patron_1)).to be_a Array
      expect(@dmns.recommend_exhibits(@patron_1)).to eq [@dead_sea_scrolls, @gems_and_minerals]
    end
  end

  describe '#patrons_by_exhibit_interest' do
    before :each do
      @gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
      @dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
      @imax = Exhibit.new({name: "IMAX",cost: 15})

      @patron_1 = Patron.new("Bob", 0)
      @patron_2 = Patron.new("Sally", 20)
      @patron_3 = Patron.new("Johnny", 5)

      @dmns.add_exhibit(@gems_and_minerals)
      @dmns.add_exhibit(@dead_sea_scrolls)

      @dmns.add_exhibit(@imax)

      @patron_1.add_interest("Gems and Minerals")
      @patron_1.add_interest("Dead Sea Scrolls")
      @patron_2.add_interest("Dead Sea Scrolls")
      @patron_3.add_interest("Dead Sea Scrolls")

      @dmns.admit(@patron_1)
      @dmns.admit(@patron_2)
      @dmns.admit(@patron_3)
    end

    it 'groups patrons by the exhibit that they are interested in' do
      expected = {
        @gems_and_minerals => [@patron_1],
        @dead_sea_scrolls => [@patron_1, @patron_2, @patron_3],
        @imax => []
      }
      expect(@dmns.patrons_by_exhibit_interest).to be_a Hash
      expect(@dmns.patrons_by_exhibit_interest).to eq expected
    end
  end

  describe '#ticket_lottery_contestants(exhibit)' do
    before :each do
      @gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
      @dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
      @imax = Exhibit.new({name: "IMAX",cost: 15})

      @patron_1 = Patron.new("Bob", 0)
      @patron_2 = Patron.new("Sally", 20)
      @patron_3 = Patron.new("Johnny", 5)

      @dmns.add_exhibit(@gems_and_minerals)
      @dmns.add_exhibit(@dead_sea_scrolls)

      @dmns.add_exhibit(@imax)

      @patron_1.add_interest("Gems and Minerals")
      @patron_1.add_interest("Dead Sea Scrolls")
      @patron_2.add_interest("Dead Sea Scrolls")
      @patron_3.add_interest("Dead Sea Scrolls")

      @dmns.admit(@patron_1)
      @dmns.admit(@patron_2)
      @dmns.admit(@patron_3)
    end

    it 'returns an array of the contestents that cant afford the exhibit they are interested in' do
      expect(@dmns.ticket_lottery_contestants(@dead_sea_scrolls)).to be_a Array
      expect(@dmns.ticket_lottery_contestants(@dead_sea_scrolls)).to eq [@patron_1, @patron_3]
      expect(@dmns.ticket_lottery_contestants(@dead_sea_scrolls)).to_not include([@patron_2])
    end
  end

  describe ' #draw_lottery_winner(exhibit)' do
    before :each do
      @gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
      @dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
      @imax = Exhibit.new({name: "IMAX",cost: 15})

      @patron_1 = Patron.new("Bob", 0)
      @patron_2 = Patron.new("Sally", 20)
      @patron_3 = Patron.new("Johnny", 5)

      @dmns.add_exhibit(@gems_and_minerals)
      @dmns.add_exhibit(@dead_sea_scrolls)

      @dmns.add_exhibit(@imax)

      @patron_1.add_interest("Gems and Minerals")
      @patron_1.add_interest("Dead Sea Scrolls")
      @patron_2.add_interest("Dead Sea Scrolls")
      @patron_3.add_interest("Dead Sea Scrolls")

      @dmns.admit(@patron_1)
      @dmns.admit(@patron_2)
      @dmns.admit(@patron_3)
    end

    it 'should select a random patron' do
      expect(@dmns.draw_lottery_winner(@dead_sea_scrolls)).to be_a Patron
      expect(@dmns.draw_lottery_winner(@gems_and_minerals)).to be_nil
    end
  end

end
