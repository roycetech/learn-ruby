class TweetsController < ApplicationController


  before_action :get_tweet , only: [:edit, :update, :destroy, :show]
  before_action :check_auth , :only => [:edit, :update, :destroy]


  def check_auth
    if session[:zombie_id] != @tweet.zombie_id
      flash[:notice] = "Sorry, you can’t edit this tweet"
      redirect_to tweets_path
    end 
  end


  def index
    puts("Total tweets: #{Tweet.count}")
    @tweets = Tweet.all
    @tweets.each do |tweet|
      puts( "#{tweet.zombie}: #{tweet.status}")
    end

    @tweets
  end




  def show
    respond_to do |format|
      format.html  # show.html.erb
      format.json { render json: @tweet }
      format.xml { render xml: @tweet }
    end
  end

  def new
    @tweet = Tweet.new
  end

  def edit
    if session[:zombie_id] != @tweet.zombie_id
      redirect_to(tweets_path, :notice =>"Sorry, you can’t edit this tweet")
    end 
  end


  def create
    @zombie = Zombie.find(params[:zombie_id])
    
    @zombie.tweets.create(tweet_params)

    # new_tweet = Tweet.create(tweet_params)
    # puts new_tweet.valid?

    # puts @zombie.valid?
    # puts @zombie.errors.messages

    # if new_tweet.valid?
    if @zombie.valid?
      redirect_to zombie_path(@zombie)
    else
      puts "New tweet invalid!"
      # render zombies_path(@zombie)      
      render 'zombies/show'
    end
  end


  def update
  end


  def destroy
  end


  private

  def get_tweet
    @tweet = Tweet.find(params[:id])
  end

  def tweet_params
    params.require(:tweet).permit(:status)
  end



end
