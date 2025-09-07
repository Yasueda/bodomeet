Rails.application.routes.draw do

  namespace :admin do
    get 'groups/index'
    get 'groups/show'
  end
  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }

  scope module: :public do
    root to: "homes#top"
    get :about, to: "homes#about"

    scope :users do
      get :my_page, to: "user#my_page"
      scope :information do
        get :edit, to: "users#edit", as: "edit_user"
        patch root to: "users#update", as: "update_user"
      end
      get :unsubcribe, to: "users#unsubcribe"
      patch :withdraw, to: "users#withdraw"
    end
    resources :users, only: :show

    resources :events
    resources :participants, only: [:create, :destroy]
    resources :comments, only: [:create, :edit, :update, :destroy]
    resources :groups
  end

  namespace :admin do
    root to: "homes#top"

    resources :users do
      member do
        get :active_switch
        get :destroy_all
      end
    end

    resources :events do
      member do
        get :active_switch
        get :destroy_all
      end
    end

    resources :participants, only: :destroy

    resources :comments, only: [:index, :destroy] do
      member do
        get :active_switch
        get :destroy_all
      end
    end

    resources :groups, only: [:index, :show, :destroy] do
      member do
        get :active_switch
        get :destroy_all
      end
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
