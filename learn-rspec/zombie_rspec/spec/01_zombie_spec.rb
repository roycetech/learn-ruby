require 'zombie'

describe Zombie do
  it 'is named Ash' do
    zombie = Zombie.new
    expect(zombie.name).to eq('Ash')
  end

  it 'has no brains' do
    zombie = Zombie.new
    zombie.brains.should < 1
    zombie.brains.should be < 1
  end

  it 'is not alive' do
    zombie = Zombie.new
    zombie.alive.should be false
  end

  it 'is rotting' do
    zombie = Zombie.new
    zombie.rotting.should be true
  end

  it 'has head' do
    zombie = Zombie.new
    zombie.headless.should_not be true
  end

  it 'is hungry' do
    zombie = Zombie.new
    zombie.should be_hungry
  end

  # 1. How do define a pending test.
  xit 'is in love'

  # 2. Another way to mark as pending, but is tagged as failed by spec runner.
  it 'is smart' do 
    pending 'Another example of pending'
  end

  it 'can get hungry' do
    zombie = Zombie.new
    expect(zombie).to respond_to(:hungry?)
  end

end