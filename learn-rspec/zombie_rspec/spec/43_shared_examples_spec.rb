require './lib/zombie'
require './lib/vampire'
require './spec/support/shared_examples_for_undead'

describe Zombie do
  it_behaves_like 'the undead', Zombie.new
end


describe Vampire do
  it_behaves_like 'the undead', Vampire.new
end