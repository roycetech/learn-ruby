class Square
  def initialize
  end

  def self.create
    Square.new
  end

  def draw
    puts 'Drawing square'
  end

end

square = Square.create
square.draw