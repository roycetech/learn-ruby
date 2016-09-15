Rails.application.routes.draw do
  get 'home/index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'tweets/index'
  get '/all' => redirect('tweets/index')

  resources :tweets

  resources :zombies do 
    resources :weapons, :tweets
    # resources :tweets
  end

  root 'home#index'

end
