# DRY Specs
require 'zombie_rspec'
require 'weapon'

describe Zombie do


  it 'has no name' do
    @zombie = Zombie.create
    @zombie.name.should be_nil
  end

  it 'craves brains' do
    @zombie = Zombie.create
    @zombie.should be_craving_brains
  end

  it 'should not be hungry after eating brains' do
    @zombie = Zombie.create
    @zombie.hungry?.should be true
    @zombie.eat(:brains)
    @zombie.hungry?.should be false
  end

end  # class
