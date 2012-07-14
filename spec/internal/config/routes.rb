Rails.application.routes.draw do
  namespace 'notches' do
    resources :hits, :only => [:new]
  end
end
