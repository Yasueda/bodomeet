Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  devise_scope :user do
    post "users/guest_sign_in", to: "public/sessions#guest_sign_in"
  end

  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }

  scope module: :public do
    root to: "homes#top"
    get :about, to: "homes#about"
    get :search, to: "searches#search"

    resources :users, only: [:index, :show] do
      collection do
        scope :information do
          get :edit
          patch "/", to: "users#update", as: "update"
        end
        get :unsubscribe
        patch :withdraw
        get :not_active
      end
      member do
        get :calendar_json, to: "users#calendar", defaults: { format: 'json' }
        get :followeds
        get :followers
        get :groups
      end
      resources :follows, only: [:create, :destroy]
    end

    resources :events do
      collection do
        get :favorite
      end
      resources :participants, only: [:create, :destroy]
      resources :favorites, only: [:create, :destroy]
      resources :comments, only: [:create, :destroy]
    end
    resources :groups do
      resources :members, only: [:create, :destroy]
    end
  end

  namespace :admin do
    root to: "homes#top"
    get :search, to: "searches#search"

    resources :users, only: [:index, :show, :edit, :update, :destroy] do
      member do
        patch :active_switch
        get :followeds
        get :followers
        get :groups
      end
      collection do
        delete :destroy_all
      end
    end

    resources :events do
      member do
        patch :active_switch
      end
      collection do
        delete :destroy_all
      end
    end

    resources :participants, only: :destroy

    resources :comments, only: [:index, :destroy] do
      member do
        patch :active_switch
      end
      collection do
        delete :destroy_all
      end
    end

    resources :groups, only: [:index, :show, :edit, :update, :destroy] do
      member do
        patch :active_switch
      end
      collection do
        delete :destroy_all
      end
    end
  end
end
