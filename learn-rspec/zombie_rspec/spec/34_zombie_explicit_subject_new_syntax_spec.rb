# DRY Specs
require 'zombie'
require 'weapon'

describe Zombie do

  context 'when hungry' do    
    context 'with a veggie preference' do

      subject(:zombie) { Zombie.new(vegetarian: true, weapons: [axe]) }
      let(:axe) { Weapon.new(name: 'axe') }

      its(:weapons) { should include(axe) }

      it 'can use its axe' do 
        zombie.swing(axe).should == true
      end

    end
  end
end  # class
