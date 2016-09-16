class Weapon

  attr_accessor :name, :damage, :type

  def initialize(opts = {})
    self.name = opts[:name] 
  end

end