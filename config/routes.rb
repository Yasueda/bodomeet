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

    scope :users do
      get :my_page, to: "users#my_page"
      scope :information do
        get :edit, to: "users#edit", as: "edit_user"
        patch :update, to: "users#update", as: "update_user"
      end
      get :unsubcribe, to: "users#unsubcribe"
      patch :withdraw, to: "users#withdraw"
    end
    resources :users, only: [:index, :show]

    resources :events do
      resources :participants, only: [:create, :destroy]
      resources :comments, only: [:create, :edit, :update, :destroy]
    end
    resources :groups do
      resources :members, only: [:create, :destroy]
    end
  end

  namespace :admin do
    root to: "homes#top"

    scope :users do
      get :destroy_all, to: "users#destroy_all", as: "users_destroy_all"
    end
    resources :users do
      member do
        get :active_switch
      end
    end

    scope :events do
      get :destroy_all, to: "events#destroy_all", as: "events_destroy_all"
    end
    resources :events do
      member do
        get :active_switch
      end
    end

    resources :participants, only: :destroy

    scope :comments do
      get :destroy_all, to: "comments#destroy_all", as: "comments_destroy_all"
    end
    resources :comments, only: [:index, :destroy] do
      member do
        get :active_switch
      end
    end

    scope :groups do
      get :destroy_all, to: "groups#destroy_all", as: "groups_destroy_all"
    end
    resources :groups, only: [:index, :show, :destroy] do
      member do
        get :active_switch
      end
    end
  end
end
