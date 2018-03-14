Rails.application.routes.draw do
  resources :players
  resources :games
  get '/games/postgame', to: 'games#postgame'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
