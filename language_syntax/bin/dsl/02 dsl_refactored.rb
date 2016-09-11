class Tweet

  def initialize(user)
    @user = user
    @tweet = []
  end

  def text(str)
    @tweet << str
  end

  def mention(user)
    @tweet << "@#{user}"
  end

  def hashtag(str)
    @tweet << "##{str}"
  end

  def link(str)
    @tweet << str
  end

  def submit_to_twitter
    tweet_text = @tweet.join(' ')
    puts "#{@user}: #{tweet_text}"
  end

end

def tweet_as(user, &block)
  tweet = Tweet.new(user)
  # yield tweet
  tweet.instance_eval(&block)
  tweet.submit_to_twitter
end


tweet_as 'royce_tech' do
  mention 'codeschool'
  text 'I made a DSL'
  hashtag 'hooray'
  hashtag 'ruby'
  link 'https://codeschool.com'
end
