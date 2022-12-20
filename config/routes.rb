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
      resources :comments, only: [:create, :destroy]
     end
    resources :users, only:[:index,:show,:edit,:update,:destroy]do
      get '/users/:id/unsubscribe' => 'users#unsubscribe', as: 'unsubscribe'
      patch '/users/:id/withdrawal' => 'users#withdrawal', as: 'withdrawal'
      member do
        get :favorites
      end
      resource :relationships, only: [:create, :destroy]
       get 'followings' => 'relationships#followings', as: 'followings'
       get 'followers' => 'relationships#followers', as: 'followers'
    end
    get "search" => "searches#search"
    resources :messages, only: [:create]
    resources :rooms, only: [:create, :index, :show]
  end
  
  #admin
  namespace :admin do
    resources :users, only:[:show,:edit,:update,:index]
    resources :posts, only:[:index, :new, :show, :edit, :create, :destroy]
  end
  
end
