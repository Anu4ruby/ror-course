RorCourse::Application.routes.draw do   
  devise_for :users
  
  match 'home/ror' => 'home#ror'
  match 'course-contents' => 'contents#index', :as => 'course_contents'
  resources :contents, :except => [:new, :create, :destroy]
    
  resources :challenges do
    collection do
      post 'submit', :action => 'result'
    end
  end
  
  resources :questions, :path => 'challenges'
  
  resources :visitor_questions, :path => 'asks', :as => 'asks', :only => [:index, :create, :show] do
    member do
      get 'respond'
      put 'respond', :action => 'responded'
    end
    collection do
      get 'pending', :as => 'not_respond', :action => 'not_respond'
      get 'page/:number', :action => 'page'
    end
  end
  
  root :to => 'home#index'

end
