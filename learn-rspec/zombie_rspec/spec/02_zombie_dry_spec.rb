# DRY Specs
require 'zombie'

describe Zombie do

  it { should respond_to(:name) }

  # Deprecated, Check out rspec-given
  its(:name) { should == 'Ash' }  # by default
  its(:craving) { should == nil }  
  its(:craving) { should be_nil }  
  
  # non-working
  # its(:weapons) { should include(weapon) }


  # Nesting Examples:
  # From:
  it 'craves brains when hungry'
  it 'with a veggie preference still craves brains when hungry'
  it 'with a veggie preference prefers vegan brains when hungry'


  # To:
  it 'craves brains when hungry'
  describe 'with a veggie preference' do
    it 'still craves brains when hungry'
    it 'prefers vegan brains when hungry'
  end
  
  # To 2
  describe 'when hungry' do
    it 'craves brains'
    describe 'with a veggie preference' do
      it 'still craves brains'
      it 'prefers vegan brains'
    end
  end


  # Or 3
  context 'when hungry' do
    it 'craves brains'
    context 'with a veggie preference' do
      it 'still craves brains'
      it 'prefers vegan brains'
    end
  end

  # Initialize with a specific constructor
  context 'when hungry' do
        
    context 'with a veggie preference' do
      subject { Zombie.new(vegetarian: true) }
      
      it 'craves brains' do
        expect(craving).to  eq('vegan brains')
      end
      # or
      its(:craving) { should == 'vegan brains' }

    end
  end




end  # class