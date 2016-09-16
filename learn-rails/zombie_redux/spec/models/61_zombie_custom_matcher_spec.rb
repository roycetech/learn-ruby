require './spec/support/61_validate_presence_of_name'

describe Zombie do
  it 'validates presence of name' do
    zombie = Zombie.new(name: nil)
    zombie.should validate_presence_of_name
  end
end