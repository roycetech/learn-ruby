class Vampire

  attr_accessor :name, :pulse

  def initialize(opts = {})
    @name = opts[:name] || 'Ash'
    self.pulse = false
  end

end