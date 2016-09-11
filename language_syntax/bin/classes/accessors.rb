# 1. Writable and Readable
class ReadWrite

  attr_accessor :name

  def initialize()
    @name = "Editable"
  end

end

obj1 = ReadWrite.new
obj1.name = "1. Really Editable"
puts(obj1.name)


# 2. Writable Only
class Writable

  attr_writer :name

  def initialize()
    @name = "Editable"
  end

  def to_s()
    @name
  end

end

obj2 = Writable.new
obj2.name = "2. Really Writable"
puts(obj2)


# 3. Readable Only
class Readable

  attr_reader :name

  def initialize()
    @name = "3. Really Readable"
  end

end

obj3 = Readable.new
# obj3.name = "Can you really write?"  # will raise an errors
puts(obj3.name)


# 4. Using self
class Selfish

  attr_reader :fish
  
  def initialize()
    self.fish = "4. initialized"
  end

  def fish=(value)
    puts('set log?')
    @fish=value
  end


end
obj4 = Selfish.new
obj4.fish= '4. Magikarp'
puts(obj4.fish)

