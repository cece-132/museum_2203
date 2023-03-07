class Patron
  attr_reader :name, :spending_money, :interests

  def initialize(name, spending_money = 0)
    @name = name
    @spending_money = spending_money
    @interests = []
  end

  def add_interest(exhibit)
    @interests << exhibit
  end

  def attend_exhibit
    
  end

end
