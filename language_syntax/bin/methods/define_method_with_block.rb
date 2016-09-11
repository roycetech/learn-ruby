class Library
  attr_accessor :games

  [:each, :map, :select].each do |method_name|
    define_method method_name do |&block|
      @games.send(method_name, &block)        
    end
  end
  
end

