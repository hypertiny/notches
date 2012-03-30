Notches::Engine.routes.draw do
  get '/hits/new' => 'hits#new', :as => :new_hit
end
