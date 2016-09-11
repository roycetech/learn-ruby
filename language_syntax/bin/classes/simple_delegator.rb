require 'delegate'

class Tweet < SimpleDelegator
  def initialize(user)
    super(user)
  end
end