Rails.application.routes.draw do
  resources :matches
  resources :players
  get '/games/newmulti', to: 'games#newmulti'
  resources :games
  root 'games#index'
  get '/games/:id/postgame', to: 'games#postgame'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
