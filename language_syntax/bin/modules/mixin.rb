require './serialize_module'

class Square
  include Serialize

end

Square.new.passivate()