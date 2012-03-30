Rails.application.routes.draw do
  resources :notches, :only => [:create]
end
