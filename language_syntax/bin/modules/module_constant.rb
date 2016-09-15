# Demonstrates that module constants are available when included
module Module1
  CONSTANT1 = 11
end

class Sample

  include Module1

  def go
    puts CONSTANT1
  end
end

Sample.new.go

