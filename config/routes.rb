Prospector::Application.routes.draw do
  get "welcome/index"
  get "home/index"
  get "home/linked_in_search"
  get "home/google_news_feed"
  get "home/twitter_search"
  get "home/twitter_timeline_search"
  get "home/email_format_search"
  get "home/email_verifier"

  root to: "home#index"

end
