class Tweet
  attr_accessor :status, :created_at

  def initialize(status)
    @status = status
    @created_at = Time.now
  end
end

Tweet.class_eval do
  attr_accessor :user
end

