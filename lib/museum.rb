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
    patron_hash = {}
      @patrons.each do |patron|
        patron_hash[patrons] = [] if patron_hash[patrons].nil?
        patron_hash[patrons] << patron
        end
      patron_hash[patrons]
  end

end
