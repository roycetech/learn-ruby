require './spec/support/64_validate_presence_of'

describe Zombie do
  it 'validates presence of name' do
    zombie = Zombie.new(name: nil)
    zombie.should validate_presence_of(:name).with_message('been eaten')
  end
end