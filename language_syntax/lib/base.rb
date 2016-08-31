class Base

  # def self.factory()
  #   return Derived.new
  # end

  def execute()
    puts 'Base class executing'
  end
end

require './lib/derived'
