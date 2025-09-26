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
        get :unsubcribe
        patch :withdraw
        get :not_active
      end
      member do
        get :calender_json, to: "users#show", defaults: { format: 'json' }
      end
    end

    resources :events do
      resources :participants, only: [:create, :destroy]
      resources :comments, only: [:create, :edit, :update, :destroy]
      collection do
        get :search
      end
    end
    resources :groups do
      resources :members, only: [:create, :destroy]
    end
  end

  namespace :admin do
    root to: "homes#top"
    get :search, to: "searches#search"

    resources :users do
      member do
        get :active_switch
      end
      collection do
        delete :destroy_all
      end
    end

    resources :events do
      member do
        get :active_switch
      end
      collection do
        delete :destroy_all
        get :search
      end
    end

    resources :participants, only: :destroy

    resources :comments, only: [:index, :destroy] do
      member do
        get :active_switch
      end
      collection do
        delete :destroy_all
      end
    end

    resources :groups, only: [:index, :show, :edit, :destroy] do
      member do
        get :active_switch
      end
      collection do
        delete :destroy_all
      end
    end
  end
end
