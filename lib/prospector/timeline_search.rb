module Prospector
  class TimelineSearch
    include Prospector::Common

    def user_timeline(screen_name)
      Rails.logger.debug "Start user_timeline"
      fetch_content(screen_name)
    end

    private

    def search_db(screen_name)
      TwitterUserTimeline.where(query: screen_name)
    end

    def fetch_from_twitter(screen_name)
      Twitter.user_timeline(screen_name)
    end

    def create_db_entry(screen_name)
      TwitterUserTimeline.find_or_initialize_by(query: screen_name)
    end
  end
end