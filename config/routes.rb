TapasRails::Application.routes.draw do

  root to: "catalog#index"
  blacklight_for :catalog
  # At some point we'll want all this, but I'm going to disable these routes
  # until we're ready to migrate to 100% Hydra-Head usage for tapas.
  devise_for :users

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Show resque admin in development environment
  resque_web_constraint = lambda do |request|
    Rails.env == "development"
  end

  # constraints resque_web_constraint do
  mount Resque::Server, at: "/resque"
  # end

  # Communities
  resources :communities
  get 'communities/:did' => 'communities#show'
  get 'communities/:did/edit' => 'communities#edit'
  post "communities/:did" => "communities#upsert"
  get 'communities' => 'communities#index'
  #get '/catalog/:id' => 'communities#show'
  # delete "communities/:did" => "communities#destroy"

  # Collections
  resources :collections
  get 'collections/:did' => 'collections#show'
  post "collections/:did" => "collections#upsert"
  get 'collections/:did/edit' => 'collections#edit'
  get 'collections' => 'collections#index'


  # delete "collections/:did" => "collections#destroy"

  # CoreFiles
  resources :core_files
  get 'core_files/:did/edit' => 'core_files#edit'
  get 'core_files' => 'core_files#index'

  get 'core_files/:did/mods' => 'core_files#mods'
  get 'core_files/:did/teibp' => 'core_files#teibp'
  get 'core_files/:did/tapas_generic' => 'core_files#tapas_generic'
  get 'core_files/:did/tei' => 'core_files#tei'
  get 'core_files/:did' => 'core_files#show'
  put 'core_files/:did/reading_interfaces' => 'core_files#rebuild_reading_interfaces'
  post 'core_files/:did' => 'core_files#upsert'
  # delete "files/:did" => "core_files#destroy"

  resources :downloads, :only => 'show'

  namespace :api do
    get 'communities/:did' => 'communities#api_show'
    get 'collections/:did' => 'collections#api_show'
    get 'core_files/:did' => 'core_files#api_show'

  end

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
