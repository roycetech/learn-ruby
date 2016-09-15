class Zombie

  attr_accessor :name, :brains, :alive, :rotting, :headless

  def initialize
    @name = 'Ash'
    @brains = 0
    @alive = false
    @rotting = true
    @headless = false
  end

  def hungry?() true end

end