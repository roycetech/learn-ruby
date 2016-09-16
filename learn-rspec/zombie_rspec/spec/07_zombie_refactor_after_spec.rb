# DRY Specs
require 'zombie_rspec'
require 'weapon'

describe Zombie do

  subject(:zombie) { Zombie.create }

  # it 'has no name' do
  #   @zombie.name.should be_nil
  # end

  its(:name) { should be_nil }

  # it 'craves brains' do
  #   zombie.should be_craving_brains
  # end

  it { should be_craving_brains }

  it 'should not be hungry after eating brains' do
    
    # @zombie.hungry?.should be true
    # @zombie.eat(:brains)
    # @zombie.hungry?.should be false

    expect { zombie.eat(:brains) }.to change { zombie.hungry? }.from(true).to(false)

  end

end  # class
