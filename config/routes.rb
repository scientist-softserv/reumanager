Rails.application.routes.draw do
  # This line mounts Refinery's routes at the root of your application.
  # This means, any requests to the root URL of your application will go to Refinery::PagesController#home.
  # If you would like to change where this extension is mounted, simply change the
  # configuration option `mounted_path` to something different in config/initializers/refinery/core.rb
  #

  resources :admin_accounts
  resources :grants
  resources :settings
  resources :snippets

  # mount Rich::Engine => '/rich', :as => 'rich'
  # mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :program_admins,
             controllers: {
               sessions: 'program_admins/sessions',
               registrations: 'program_admins/registrations'
             }
  namespace :reu_program do
    get 'dashboard' => 'dashboard#index'
    resources :settings, except: %i[destroy]
    resources :snippets, except: %i[destroy]
    resources :applicants, except: %i[destroy]
    resources :application_forms, except: %i[destroy] do
      member do
        patch :update_attributes
      end
    end
  end

  namespace :applicants do
    get "recommendations/:token" => "recommendations#edit", as: :recommendations_edit
    post "recommendations/:id" => "recommendations#resend_request", as: :recommendations_request
    put "recommendations/:token" => "recommendations#update", as: :recommendations_update

    get "recommenders" => "recommenders#edit"
    put "recommenders" => "recommenders#update"

    get "records" => "academic_records#edit"
    put "records" => "academic_records#update"
    delete "records" => "academic_records#destroy"
  end

  devise_for :applicants, :controllers => { :confirmations => "applicants/confirmations", :registrations => "applicants/registrations", :sessions => "applicants/sessions" }

  devise_scope :applicant do
    get "applicants/status" => "applicants/registrations#status", :as => :applicant_status
    get "applicants/submit" => "applicants/registrations#submit", :as => :submit_application
  end

  devise_for :users, :controllers => { :sessions => "users/sessions" }

  devise_scope :user do
    get "users/sign_out" => "devise/sessions#destroy"
  end

  get "closed" => "welcome#closed"
  get "thanks" => "welcome#thanks"

  # We ask that you don't use the :as option here, as Refinery relies on it being the default of "refinery"
  # constraints subdomain: 'www' do
    # mount Refinery::Core::Engine, at: '/reu_info' # Refinery::Core.mounted_path
  # end

  root :to => "welcome#index"

end
