Rails.application.routes.draw do
  resources :grants
  devise_for :users

  namespace :reu_program do
    get 'dashboard' => 'dashboard#index'
    resources :program_admins, except: %i[destroy] do
      member do
        get :lock
        get :unlock
      end
    end
    resources :settings, except: %i[destroy]
    resources :snippets, except: %i[destroy]
    resources :applicants, except: %i[destroy] do
      member do
        patch :accept
        patch :reject
      end
    end

    resources :application_forms, except: %i[new create destroy] do
      member do
        get :show_schema
        get :make_active
      end
      resources :sections, except: %i[index] do
        member do
          patch :update_attributes
        end
      end
    end
    resources :recommender_forms, except: %i[new create destroy] do
      member do
        get :show_schema
      end
      resources :sections, except: %i[index] do
        member do
          patch :update_attributes
        end
      end
    end
  end

  get 'application' => 'applications#show_application'
  match 'application' => 'applications#update_application', via: %i[put patch]
  get 'recommenders' => 'applications#show_recommenders'
  match 'recommenders' => 'applications#update_recommenders', via: %i[put patch]
  get 'recommendations' => 'applications#show_recommendations'
  match 'recommendations' => 'applications#update_recommendations', via: %i[put patch]
  get 'status' => 'applications#status'
  get '/recommenders/:id/resend' => 'applications#resend', as: 'recommenders_resend'

  get 'closed' => 'welcome#closed'
  get 'thanks' => 'welcome#thanks'
  root to: 'welcome#index'
end
