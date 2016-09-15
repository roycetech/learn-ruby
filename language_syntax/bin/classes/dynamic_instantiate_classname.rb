
class Sample
  def initialize()
    puts "Initialized"
  end
end

Object::const_get('Sample').new

