require './app/models/zombie'
require 'mocha'

describe Zombie do

  let(:zombie) { Zombie.create }

  context "#decapitate" do

    # Outdated, and does not work!    
    xit 'calls weapon.slice' do
      zombie.weapon.stubs(:slice)
      zombie.weapon.should_receive(:slice)
      zombie.decapitate
    end

    it 'sets status to "dead again"' do
      zombie.weapon.stubs(:slice)
      zombie.decapitate
      zombie.status.should == 'dead again'
    end

    
  end
end