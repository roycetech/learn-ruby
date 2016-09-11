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
    puts "#{@user}: #{tweet_text}"
    puts @annotations.inspect unless @annotations.empty?
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
  mention 'codeschool', 'envylabs'
  text 'I made a DSL'
  hashtag 'hooray', 'ruby'
  link 'https://codeschoo.com'
  lat 28.415833  
  lng -81.298889
  keywords 'Ruby', 'DSL'
end
