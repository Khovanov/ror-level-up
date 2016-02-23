Rails.application.routes.draw do
  use_doorkeeper

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  devise_scope :user do
    post '/finish_sign_in' => 'omniauth_callbacks#finish_sign_in'
  end
  
  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end
    end
  end

  root 'questions#index'

  resources :attachments, only: :destroy
  # resources :comments, only: [:create, :destroy]

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
      patch :vote_cancel
    end
  end

  # resources :questions, concerns: [:votable, :commentable, :subsribable], except: [:edit], shallow: true do
  #   resources :answers, concerns: [:votable, :commentable], except: [:index, :show, :edit] do

  resources :questions, concerns: :votable do
    resources :comments, only: :create, defaults: {commentable: 'questions'}
    resources :answers, concerns: :votable do
      resources :comments, only: :create, defaults: {commentable: 'answers'}
      patch :best, on: :member
    end
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
