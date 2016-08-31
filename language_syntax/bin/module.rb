# class Car
# 
  # def colour
    # @colour 
  # end  
#   
  # private 
  # def colour= value
    # @colour = value
# end end
# 
# 
# car = Car.new
# puts car.colour.nil?
# car.colour = "red"
# puts car.colour


def villain_superhero_proc
  winner = Proc.new { return "Villain Wins!" }
  winner.call
  "Superhero Wins!"
end

puts "1 " + villain_superhero_proc

def villain_superhero_lambda
  winner = lambda { return "Villain Wins!" }
  winner.call
  "Superhero Wins!"

end
puts "2 " + villain_superhero_lambda