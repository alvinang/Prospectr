module Prospector
  class TwitterCachingClient

    def initialize()
      Twitter.connection_options = {:timeout => 30, :open_timeout => 2}
    end

    def user_search(query)
      user_search_client.user_search(query)
    end

    def user_timeline(screen_name)
      timeline_search_client.user_timeline(screen_name)
    end

    private

    def user_search_client
      @user_search_client ||= Prospector::UserSearch.new
    end

    def timeline_search_client
      @timeline_client ||= Prospector::TimelineSearch.new
    end
  end
end
