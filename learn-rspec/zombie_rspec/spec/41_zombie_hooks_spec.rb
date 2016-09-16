# DRY Specs
require 'zombie_rspec'
require 'weapon'


describe Zombie do

  let(:zombie) { Zombie.new }

  # 1. before
  # it 'is hungry' do
  #   zombie.hungry!
  #   zombie.should be_hungry
  # end

  # it 'craves brains' do
  #   zombie.hungry!
  #   zombie.should be_craving_brains
  # end

  # After
  before { zombie.hungry! }
  it 'is hungry' do
    zombie.should be_hungry
  end

  it 'craves brains' do
    zombie.should be_craving_brains
  end




end  # class
