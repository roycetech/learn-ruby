require './lib/51_zombie'



describe Zombie do

  let(:zombie) { Zombie.create }

  context "#decapitate" do
    
    it 'calls weapon.slice' do
      zombie.weapon.should_receive(:slice)
      zombie.decapitate
    end

    it 'sets status to "dead again"' do
      zombie.wapon.stub(:slice)
      zombie.decpitate
      zombie.status.should == 'dead agani'
  end

  # subject(:zombie) { Zombie.new }


  # # def slice(*args)
  # #   nil
  # # end

  # it 'decapitates' do
  #   zombie.weapon.stub(:slice)
  # end

end