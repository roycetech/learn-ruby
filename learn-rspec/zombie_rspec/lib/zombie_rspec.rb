class Zombie

  attr_accessor :name, :brains, :alive, :rotting, :headless, :vegetarian, :craving, :weapons

  def initialize(opts = {})
    @name = opts[:name]
    @weapons = opts[:weapons] || []
    @brains = 0
    @alive = false
    @rotting = true
    @headless = false
    @craving = true
    @hungry = true
  end

  def self.create(opts = {})
    Zombie.new(opts)
  end

  def swing(weapon) weapon && true end
  
  def craving_brains?
    @craving
  end

  def hungry?
    @hungry
  end

  def eat(brains)
    @hungry = false
  end


end