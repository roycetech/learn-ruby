class Game

  def initialize(&block)
    if block_given?
      self.instance_eval(&block)
    end
  end

  def owner(name=nil)
    if name
      @owner = name
    else
      @owner
    end
  end
  
end

