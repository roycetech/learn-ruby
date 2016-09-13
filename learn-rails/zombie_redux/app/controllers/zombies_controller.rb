class ZombiesController < ApplicationController


  http_basic_authenticate_with name: "dhh", password: "secret", except: [:index, :show]

  before_action :get_zombie , only: [:show, :edit, :update, :destroy]
  
  
  def index
    @zombies = Zombie.all
  end


  def show
  end


  def new
    @zombie = Zombie.new
  end


  def edit
  end

   
  def create
    @zombie = Zombie.new(zombie_params)
   
    if @zombie.save
      redirect_to @zombie
    else
      render 'new'
    end
  end


  def update
    if @zombie.update(zombie_params)
      redirect_to @zombie
    else
      render 'edit'
    end
  end


  def destroy
    @zombie.destroy
   
    redirect_to zombies_path
  end
 

  private

  def get_zombie
    @zombie = Zombie.find(params[:id])
  end
  
  def zombie_params
    params.require(:zombie).permit(:name, :graveyard)
  end


end
