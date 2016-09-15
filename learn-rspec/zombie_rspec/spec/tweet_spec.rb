require 'spec_helper'
require 'tweet'

# describe Tweet do
#   it "has a status of 'Nom nom nom'" do
#     tweet = Tweet.new(status: 'Nom nom nom')
#     tweet.status.should be == 'Nom nom nom'
#   end
# end

describe Tweet do
  it "has a status of 'Nom nom nom'" do
    tweet = Tweet.new(status: 'Nom nom nom')
    tweet.status.should be == "Nom nom nom"
  end
end



