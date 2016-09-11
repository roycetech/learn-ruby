require './serialize_module'

class Square
  extend Serialize

end

Square.passivate()