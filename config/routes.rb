Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  post "api/create", to: "api/convert#create"

  post "document/create", to: "document#create", as: "document_create"
  root to: "document#index"

  Rails.application.routes.draw do
    # IMPORTANT: Make sure the mount path does not contain any special characters
    # Use a simple path like '/active-storage-dashboard' or '/storage-dashboard'
    # This is crucial for proper URL generation
    mount ActiveStorageDashboard::Engine, at: "/active-storage-dashboard"
  end
end
