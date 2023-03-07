require 'pry'
class Museum
  attr_reader :name, :exhibits, :patrons

  def initialize(name)
    @name = name
    @exhibits = []
    @patrons = []
  end

  def recommend_exhibits(patron)
    @exhibits.map do |exhibit|
      exhibit if patron.interests.include?(exhibit.name)
    end.compact.sort_by { |exhibit| exhibit.name }
  end

  def add_exhibit(exhibit)
    @exhibits << exhibit
  end

  def admit(patron)
    @patrons << patron
  end

  def patrons_by_exhibit_interest
    hash = exhibit_hash
    @patrons.each do |patron|
      recommend_exhibits(patron).each do |exhibit|
        hash[exhibit] << patron
      end
    end
    hash
  end

  def exhibit_hash
    hash = {}
    @exhibits.each do |exhibit|
      hash[exhibit] = [] if !hash[exhibit]
    end
    hash
  end

  def ticket_lottery_contestants(exhibit)
    exhibit_cost = @exhibits.find {|ex| ex.name == exhibit.name}.cost
    patrons_by_exhibit_interest[exhibit].map { |patron| patron if patron.spending_money < exhibit_cost }.compact
  end

  def draw_lottery_winner(exhibit)
    ticket_lottery_contestants(exhibit).sample
  end

end
