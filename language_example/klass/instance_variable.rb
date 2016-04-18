class SampleClass
  
  @variable = 'World'  # This does NOT work at all!
  
  def initialize
    @variable = 'Hello'
  end
  
  def variable
    @variable
  end
  
end

puts SampleClass.new.variable
