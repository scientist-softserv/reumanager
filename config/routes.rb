Rails.application.routes.draw do
  devise_for :users

  namespace :reu_program do
    get 'dashboard' => 'dashboard#index'
    resources :invoices
    resources :charges, only: %i[new create]
    resources :program_admins, except: %i[destroy] do
      member do
        get :lock
        get :unlock
      end
    end
    resources :settings, except: %i[destroy]
    resources :snippets, except: %i[destroy]
    resources :applications, except: %i[destroy] do
      member do
        patch :accept
        patch :reject
        patch :change_state
      end
    end

    resources :application_forms, except: %i[new create destroy] do
      member do
        get :show_schema
        get :make_active
        get :duplicate
        get :reorder_sections
      end
      resources :sections, except: %i[index] do
        member do
          get :reorder_fields
        end
        resources :fields, except: %i[index]
      end
    end
    resources :recommender_forms, except: %i[new create destroy] do
      member do
        get :show_schema
        get :make_active
        get :duplicate
      end
      resources :sections, except: %i[index] do
        member do
          get :reorder_fields
        end
        resources :fields, except: %i[index]
      end
    end
  end

  # application routes
  get 'application' => 'applications#show_application'
  match 'application' => 'applications#update_application', via: %i[put patch]
  get 'status' => 'applications#status'
  get 'submit' => 'applications#submit'
  get 'withdraw' => 'applications#withdraw'
  get 'restart' => 'applications#restart'

  # recommender routes
  get 'recommenders' => 'recommender_forms#show_recommenders'
  match 'recommenders' => 'recommender_forms#update_recommenders', via: %i[put patch]
  get '/recommenders/:id/resend' => 'recommender_forms#resend', as: 'recommenders_resend'

  # recommendation routes
  get 'recommendations' => 'recommendations#show_recommendations'
  match 'recommendations' => 'recommendations#update_recommendations', via: %i[put patch]

  # support page route
  post "send_support_email" => "support#send_support_email"

  # data url file download route
  get 'download/:model_type/:model_id/:field' => 'download#download', constraints: { format: /pdf/ }, as: :download

  # welcome routes
  get 'closed' => 'welcome#closed'
  get 'thanks' => 'welcome#thanks'
  root to: 'welcome#index'

  resources :grants do
    collection do
      post :create_program
    end
  end

  get 'react_playground' => 'welcome#react_playground'
  # marketing routes
  get 'tours' => 'welcome#tours'
  get 'pricing' => 'welcome#pricing'
  get 'create_grant' => 'grants#new_program'
  get 'demo' => 'welcome#demo'
  get 'support' => 'welcome#support'
end
