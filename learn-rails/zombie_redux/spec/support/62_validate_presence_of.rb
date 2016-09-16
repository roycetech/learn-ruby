module ValidatePresenceOf
  
  class Matcher

    def initialize(attribute)
      @attribute = attribute
    end

    def matches?(model)
      model.valid?
      model.errors.has_key?(@attribute)
    end
  end

  def validate_presence_of(attribute)
    Matcher.new(attribute)
  end
end

RSpec.configure do |config|
  config.include ValidatePresenceOf, type: :model
end
