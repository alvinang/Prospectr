module Prospector
  class UserSearch
    include Prospector::Common

    def user_search(query)
      Rails.logger.debug "Start user_search"
      fetch_content(query)
    end

    private

    def search_db(query)
      TwitterUserSearch.where(query: query)
    end

    def fetch_from_twitter(query)
      Twitter.user_search(query, lang: "en")
    end

    def create_db_entry(query)
      TwitterUserSearch.find_or_initialize_by(query: query)
    end
  end
end
