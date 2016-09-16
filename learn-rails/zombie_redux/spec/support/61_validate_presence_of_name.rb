module ValidatePresenceOfName
  class Matcher
    def matches?(model)
      model.valid?
      model.errors.has_key?(:name)
    end
  end

  def validate_presence_of_name
    Matcher.new
  end
end

RSpec.configure do |config|
  config.include ValidatePresenceOfName, type: :model
end
