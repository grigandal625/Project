UIR::Application.routes.draw do
  
  get "auth/login", to: "auth#login", as: "login"
  post "auth/authentificate"
  post "auth/logout", as: "logout"
  get  "auth/logout", as: "get_logout"

  get '/ka_welcome',               to: 'ka_welcome#index',    as: :ka_welcome

  get  '/ka_topics',               to: 'ka_topics#index',     as: :ka_topics
  get  '/ka_topics/all',           to: 'ka_topics#all',       as: :all_ka_topics
  get  '/ka_topics/:id',           to: 'ka_topics#show',      as: :ka_topic
  get  '/ka_topics/destroy/:id',   to: 'ka_topics#destroy',   as: :ka_topic_destroy
  post '/ka_topics/new',           to: 'ka_topics#new',       as: :new_ka_topic
  get  '/ka_topics/edit/:id',      to: 'ka_topics#edit',      as: :edit_ka_topic
  post '/ka_topics/edit_text/:id', to: 'ka_topics#edit_text', as: :edit_ka_topic_text

  get  '/ka_questions',             to: 'ka_questions#index',   as: :ka_questions
  get  '/ka_questions/:id',         to: 'ka_questions#show',    as: :ka_question
  get  '/ka_questions/destroy/:id', to: 'ka_questions#destroy', as: :ka_question_destroy
  post '/ka_questions/new',         to: 'ka_questions#new',     as: :new_ka_question
  post '/ka_questions/edit/:id',    to: 'ka_questions#edit',    as: :edit_ka_question
  get  '/ka_questions/show/:id',    to: 'ka_questions#show',    as: :show_ka_question

  get  '/ka_answers',             to: 'ka_answers#index',   as: :ka_answers
  get  '/ka_answers/destroy/:id', to: 'ka_answers#destroy', as: :ka_answer_destroy
  post '/ka_answers/new',         to: 'ka_answers#new',     as: :new_ka_answer
  post '/ka_answers/edit/:id',    to: 'ka_answers#edit',    as: :edit_ka_answer

  get  '/ka_tests',             to: 'ka_tests#index',   as: :ka_tests
  get  '/ka_tests/new',         to: 'ka_tests#new',     as: :new_ka_test
  get  '/ka_tests/:id',         to: 'ka_tests#show',    as: :ka_test
  get  '/ka_tests/destroy/:id', to: 'ka_tests#destroy', as: :ka_test_destroy
  post '/ka_tests',             to: 'ka_tests#save',    as: :save_ka_test
  post '/ka_tests/edit',        to: 'ka_tests#edit',    as: :edit_ka_tests
  get  '/ka_tests/run/:id',     to: 'ka_tests#run',     as: :run_ka_test

  post '/ka_variant/check/:id', to: 'ka_variants#check', as: :check_ka_variant

  get '/ka_results',                   to: 'ka_results#index',  as: :ka_results
  get '/ka_results/show/:test_id',     to: 'ka_results#show',   as: :show_ka_results
  get '/ka_results/detail/:result_id', to: 'ka_results#detail', as: :show_detail_ka_result
  get '/ka_results/recalc/:id',        to: 'ka_results#recalc', as: :recalc_ka_results

  get 'ka_results/:test_id/problem_areas_and_competences_coverage' => 'ka_results#show_problem_areas_and_competences_coverage', as: :problem_areas_and_competences_coverage

  resources :competences
  post 'competences/attach' => 'competences#attach'
  get 'competence/:c_id/detach_from/:t_id' => 'competences#detach', as: :competence_detach

  resources :constructs
  post 'constructs/attach' => 'constructs#attach'
  get 'constructs/:c_id/detach_from/:t_id' => 'constructs#detach', as: :construct_detach

  get 'ka_topics/:root_id/topics_with_questions' => 'ka_topics#show_topics_with_questions', as: :topics_with_questions
  get 'ka_topics/:root_id/all_competences' => 'ka_topics#show_all_competences', as: :all_competences
  get 'ka_topics/:root_id/all_constructs' => 'ka_topics#show_all_constructs', as: :all_constructs

  post "frameadmin/createframe"
  post "frameadmin/updateframe"
  get "frameadmin/results"
  get "frameadmin/mistakes"

  post "framestudent/createstudentframe"
  post "framestudent/updateframe"
  post "framestudent/finalframe"

  get "groups/:id/generate_pass", to: "groups#generate_pass", as: "pass_gen"
  get "groups/:id/generate_report", to: "groups#generate_report", as: "report_gen"
  get  "semanticanswers/result"

  post "students/passupdate"
  resources :tasks, only: [:index, :new, :create, :edit, :update, :destroy]

  resources :results
  resources :frameadmin
  resources :framestudent

  resources :groups do
    resources :students, only: [:create, :show, :destroy]
  end
   get "semantictests/results"
   

  resources :menu
  resources :semantictests
  resources :semanticanswers
  resources :personality_tests do
    get :results, on: :collection
    post :save_results, on: :collection
    post :remove_from_student, on: :collection, as: :remove_test_from_student
  end
  resources :personality_test_questions, except: [:create, :index] do
    post :batch_update, on: :collection
  end
  resources :personality_test_answers, only: [:new, :update, :destroy]
  resources :personality_test_answer_pictures, only: [:create, :update]
  resources :personality_test_question_pictures, only: [:create, :update]
  resources :personalities, only: [:index, :new, :update, :destroy]
  resources :personality_traits, only: [:index, :new, :update, :destroy]
  resources :personality_trait_intervals, only: [:new, :update, :destroy]
  resources :personality_test_answer_weights, only: [:new, :update, :destroy]

  resources :methodical_materials, except: [:edit, :create]

  post "semanticanswers/create"
  post "semanticanswers/updatesemanticjson"
  post "semantictests/updateJson"
  post "semanticanswers/getmistakes"
  get  "semanticanswers/new"
  get  "menu/results"

  root 'menu#index'
  get "test", to: "test#get_task", as: "get_task"
  post "test", to: "test#next_component", as: "next_component"


  get  "planning/_index"
  get  "planning/test_run"
  get  "planning/new_session"
  get  "planning/close_session"
  get  "planning/update"
  get  "planning/begin_task"
  get  "planning/close_task"

  get  "dummy/index"
  get  "dummy/execute"
  get  "dummy/commit"
  
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
