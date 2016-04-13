module MyApp
  
  local_var = "royce"
  
  def self.hello
    # puts "Hello" + local_var
    world
  end

  def world
    puts "World" + local_var
  end

  
end

MyApp::hello
