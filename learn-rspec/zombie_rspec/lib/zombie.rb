class Zombie

  attr_accessor :name, :brains, :alive, :rotting, :headless, :vegetarian, :craving, :weapons, :pulse

  def initialize(opts = {})
    @name = opts[:name] || 'Ash'
    @weapons = opts[:weapons] || []
    @brains = 0
    @pulse = false
    @alive = false
    @rotting = true
    @headless = false
    @craving = 'vegan brains' if opts[:vegetarian] == true
  end

  def self.create(opts = {})
    Zombie.new(opts)
  end

  def hungry?() true end

  def swing(weapon) weapon && true end


end