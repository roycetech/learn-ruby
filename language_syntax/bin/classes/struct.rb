# Define a struct with #to_s
Game = Struct.new(:name, :year, :system) do 
  def to_s
    "#{name} #{year} #{system}"
  end  
end


