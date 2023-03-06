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

  xit "has patrons" do
    patron_1.add_interest("Gems and Minerals")
    patron_1.add_interest("Dead Sea Scrolls")
    patron_2.add_interest("Dead Sea Scrolls")
    patron_3.add_interest("Dead Sea Scrolls")
  end

  xit "groups patrons by exhibit interest" do
    gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
    imax = Exhibit.new({name: "IMAX",cost: 15})

    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)

    expect(dmns.exhibits).to eq([gems_and_minerals, dead_sea_scrolls, imax])
    expect(dmns.patrons).to eq ([])

    patron_1 = Patron.new("Bob", 0)
    patron_2 = Patron.new("Sally", 20)
    patron_3 = Patron.new("Johnny", 5)

    patron_1.add_interest("Gems and Minerals")
    patron_1.add_interest("Dead Sea Scrolls")
    patron_2.add_interest("Dead Sea Scrolls")
    patron_3.add_interest("Dead Sea Scrolls")

    dmns.admit(patron_1)
    dmns.admit(patron_2)
    dmns.admit(patron_3)

    expect(dmns.patrons_by_exhibit_interest).to eq({gems_and_minerals: ["Bob"], dead_sea_scrolls: ["Bob","Sally","Johnny"], imax: []})

  end

  xit "can use the grouped patrons to choose a lottery winner" do
    dmns = Museum.new("Denver Museum of Nature and Science")

    expect(dmns.exhibits).to be_empty

    gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
    imax = Exhibit.new({name: "IMAX",cost: 15})

    dmns.add_exhibit(gems_and_minerals)
    dmns.add_exhibit(dead_sea_scrolls)
    dmns.add_exhibit(imax)

    expect(dmns.exhibits).to eq(["gems_and_minerals", "dead_sea_scrolls", "imax"])
    expect(dmns.patrons).to eq be_empty

    patron_1 = Patron.new("Bob", 0)
    patron_2 = Patron.new("Sally", 20)
    patron_3 = Patron.new("Johnny", 5)

    patron_1.add_interest("Gems and Minerals")
    patron_1.add_interest("Dead Sea Scrolls")
    patron_2.add_interest("Dead Sea Scrolls")
    patron_3.add_interest("Dead Sea Scrolls")

    dmns.admit(patron_1)
    dmns.admit(patron_2)
    dmns.admit(patron_3)

    expect(dmns.patrons_by_exhibit_interest).to eq({gems_and_minerals: ["Bob"], dead_sea_scrolls: ["Bob","Sally","Johnny"], imax: []})

    expect(dmns.ticket_lottery_contestants(dead_sea_scrolls)).to eq(dead_sea_scrolls:["Bob","Sally","Johnny"])

    dmns.draw_lottery_winner(dead_sea_scrolls)

    expect(dmns.ticket_lottery_contestants(dead_sea_scrolls)).to eq(dead_sea_scrolls.sample)
    # I know it is supposed to == one of the people interested.
    # I know it should be a randomw sample and should be choosing from an array.
    # I think once chosen we want to remove them from the lottery array
    # finished tests @9:55am gonna take a pom
    # started writing code @ 10:00
    # finished exhibit tests @ 10:10
    # finished patron tests @ 10:30...had trouble figuring out the last test, moving on
    # second to last in museum test I had trouble turning the patron interests into keys for my hash

  end

end
