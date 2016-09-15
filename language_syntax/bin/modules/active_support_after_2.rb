require 'active_support/concern'

module Module1
  extend ActiveSupport::Concern

  def mod1() 1; end
end

module Module2
  extend ActiveSupport::Concern
  include Module1

  def mod2
    puts Module1.mod1()
    puts 2
  end

  Constant = lambda { puts Module1.mod1() }
end

class Sample
  include Module2
  def go
    mod2
    Constant.call
  end
end

class Sample2
  include Module1
  def go
    mod1()
  end
end


Sample.new.go
Sample2.new.go

