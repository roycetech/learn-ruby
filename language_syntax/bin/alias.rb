$GlobalVar = 'Test Global Variable'

alias $GV $GlobalVar 

class Alias
  
  def meth
    puts('Method called')
  end
  
end

class AliasSub < Alias
  
  def meth
    puts 'Override!'
  end
  
  alias :m :meth

end

a = Alias.new
puts a.meth

puts $GV


a = AliasSub.new
a.m
