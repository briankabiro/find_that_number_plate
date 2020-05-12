Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "home#index"
  post :search, to: "home#search"

  get :index, to: "counties#index"
  post :search, to: "counties#search"
end
