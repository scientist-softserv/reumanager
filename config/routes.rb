Rails.application.routes.draw do
  resources :grants

  devise_for :users
  devise_for :program_admins
  devise_for :applicants

  namespace :reu_program do
    get 'dashboard' => 'dashboard#index'
    resources :settings, except: %i[destroy]
    resources :snippets, except: %i[destroy]
    resources :applicants, except: %i[destroy]
    resources :application_forms, except: %i[new create destroy] do
      member do
        get :show_schema
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

  get 'application' => 'applicant_data#show_application'
  match 'application' => 'applicant_data#update_application', via: %i[put patch]
  get 'recommenders' => 'applicant_data#show_recommenders'
  match 'recommenders' => 'applicant_data#update_recommenders', via: %i[put patch]
  get 'status' => 'applicant_data#status'
  
  get 'closed' => 'welcome#closed'
  get 'thanks' => 'welcome#thanks'
  root to: 'welcome#index'
end
