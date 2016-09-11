# Allows optional Text and optional block
class Tweet

  def initialize(user)
    @user = user
    @tweet = []
    @annotations = {}
  end

  def text(str)
    @tweet << str
    self
  end

  def mention(*users)
    users.each do |user|
      @tweet << "@#{user}"
    end
    self
  end

  def hashtag(*tags)
    tags.each do |tag|
      @tweet << "##{tag}"
    end
    self
  end

  def link(str)
    @tweet << str
    self
  end

  def submit_to_twitter
    tweet_text = @tweet.join(' ')
    if tweet_text.length <= 140
      puts "#{@user}: #{tweet_text}"
      puts @annotations.inspect unless @annotations.empty?
    else
      raise "Your tweet is too long!"
    end
  end

  def method_missing(method_name, *args)
    @annotations[method_name] = args.join(', ')
  end

end

def tweet_as(user, text = nil, &block)
  tweet = Tweet.new(user)  
  tweet.text(text) if text
  tweet.instance_eval(&block) if block_given?()
  tweet.submit_to_twitter
end


tweet_as 'royce_tech' do
  
  text %s(The block that you pass to define_method can include some parameters. That's how your defined method accepts arguments. When you define a method you're really just nicknaming the block and keeping a reference to it in the class.)

  hashtag 'lol', 'twitter'
end
