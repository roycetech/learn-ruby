# DRY Specs
require 'zombie_rspec'
require 'weapon'


describe Zombie do

  let(:zombie) { Zombie.new }

  before { zombie.hungry! }
  it 'is hungry' do
    zombie.should be_hungry
  end

  it 'craves brains' do
    zombie.should be_craving_brains
  end

  context 'with a veggie preference' do
    before { zombie.vegetarian = true }
    it 'still craves brains'
    it 'craves vegan brains'
  end


end  # class
