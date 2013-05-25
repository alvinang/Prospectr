Prospector::Application.routes.draw do
  get "welcome/index"
  get "home/index"

  root to: "home#index"

end
