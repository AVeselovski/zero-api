# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "auth/login", to: "authentication#create_token"
      post "auth/register", to: "authentication#create_user"

      resources :boards do
        resources :lists do
          member do
            patch :move
          end

          resources :cards do
            member do
              patch :move
            end
          end
        end
      end
    end
  end
end
