require './app/models/zombie'

describe Zombie do
  it 'is invalid without a name' do
    zombie = Zombie.new
    zombie.should_not be_valid
  end

  it 'has a name that matches "Ash Clone"' do
    zombie = Zombie.new(name: 'Ash Clone')
    zombie.name.should match(/Ash Clone/)
  end

  it 'include tweets' do
    tweet1 = Tweet.new(status: 'Uuuuunhhhhh')
    tweet2 = Tweet.new(status: 'Arrrrgggg')
    zombie = Zombie.new(name: 'Ash', tweets: [tweet1, tweet2])

    zombie.tweets.should include(tweet1)
    zombie.tweets.should include(tweet2)
  end

  it 'starts with no weapon' do
    zombie = Zombie.new(name: 'Ash')
    zombie.should have(0).weapons
    # Other matchers: have_at_least(n), have_at_most(n)
  end

  it 'changes the number of Zombies' do
    zombie = Zombie.new(name: 'Ash')
    expect { Zombie.create(name: 'Ash', graveyard: 'Loyola Memorial') }.to change { Zombie.count }.by(1)
    # Other modifiers: from(n), to(n)
  end

  it 'raises an error if saved without a name' do
    zombie = Zombie.new
    expect { zombie.save! }.to raise_error(ActiveRecord::RecordInvalid)
    # other modifiers: not_to, to_not
  end

  it 'can get hungry' do
    zombie = Zombie.new
    expect(zombie).to respond_to(:hungry?)
  end


  # Other Matchers: 
  # be_within(<range>).of(<expected>)
  # exist
  # satisfy { <block> }
  # be_kind_of(<class>)
  # be_an_instance_of(<class>)


end