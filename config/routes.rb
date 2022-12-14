Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "homes#top"
  get "home/about"=>"homes#about", as: 'about'
  
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }
  
  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions',
    passwords: 'public/passwords'
  }
  
  devise_scope :user do
    post 'users/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end
  
  #user
  namespace :user do
    resources :posts, only:[:new,:index,:show,:edit,:create,:destroy,:update]do
      resource :favorites, only: [:create, :destroy]
     end
    resources :users, only:[:index,:show,:edit,:update,:destroy]do
      member do
        get :favorites
      end
    end
  end
end
