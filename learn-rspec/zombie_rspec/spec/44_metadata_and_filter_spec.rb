require './lib/zombie'


# This example demonstrates the tag :focus, and :vegan
# run with: rspec --tag vegan spec/44_metadata_and_filter_spec.rb
# run with: rspec --tag focus spec/44_metadata_and_filter_spec.rb

describe Zombie do
  context 'when hungry' do
    it 'wants brains'
    context 'with a veggie preference', focus: true do
      it 'still craves brains'
      it 'prefers vegan brains', vegan: true
    end
  end
end