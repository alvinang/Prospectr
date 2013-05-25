Prospector::Application.routes.draw do
  get "welcome/index"
  get "home/index"
  get "home/linked_in_search"

  root to: "home#index"

end
