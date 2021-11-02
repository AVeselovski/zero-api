Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :boards do
        resources :lists do
          resources :cards
        end
      end
    end
  end
end
