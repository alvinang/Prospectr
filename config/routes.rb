Prospector::Application.routes.draw do
  devise_for :users, path_names: {sign_in: "login", sign_out: "logout"}

  authenticated :user do
    get "welcome/index"
    get "home/index"
    get "home/linked_in_search"
    get "home/google_news_feed"
    get "home/google_search"
    get "home/twitter_search"
    get "home/twitter_timeline_search"
    get "home/email_format_search"
    get "home/email_verifier"

  end
  root to: "home#index"
end
