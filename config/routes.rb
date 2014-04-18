UIR::Application.routes.draw do
  
  get "auth/login", to: "auth#login", as: "login"
  post "auth/authentificate"
  post "auth/logout", as: "logout"

  get "groups/:id/generate_pass", to: "groups#generate_pass", as: "pass_gen"
  get "groups/:id/generate_report", to: "groups#generate_report", as: "report_gen"
  get  "semanticanswers/result"
  resources :tasks, only: [:index, :new, :create, :edit, :update, :destroy]

  resources :results

  resources :groups do
    resources :students, only: [:create, :show, :destroy]
  end
   get "semantictests/results"
   

  resources :menu
  resources :semantictests
  resources :semanticanswers
  post "semanticanswers/create"
  post "semanticanswers/updatesemanticjson"
  post "semantictests/updateJson"
  post "semanticanswers/getmistakes"
  get  "semanticanswers/new"
  get  "menu/results"
   

  root 'menu#index'
  get "test", to: "test#get_task", as: "get_task"
  post "test", to: "test#next_component", as: "next_component"

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
