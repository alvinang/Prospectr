module Prospector
  module UserSearch
    def user_search(query)
      if user_search_cached?(query) and not user_search_cache_expired?(query)
        Rails.logger.debug "Returning cached response to search for user #{query}"
        user_search_from_cache(query)
      else
        Rails.logger.debug "Not in cache or cache expired. Using twitter client to search for user #{query}"
        result = user_search_from_twitter(query)
        json_value = cache_user_search_in_db(query, result)
        json_value
      end
    end

    private

    def user_search_cached?(query)
      TwitterUserSearch.where(query: query).any?
    end

    def user_search_from_cache(query)
      TwitterUserSearch.where(query: query).first.result
    end

    def user_search_from_twitter(query)
      Twitter.user_search(query, lang: "en")
    end

    def cache_user_search_in_db(query, user_search_result)
      Rails.logger.debug "Caching in database the user search for #{query} : #{user_search_result.to_json}"
      result = TwitterUserSearch.find_or_initialize_by(query: query)
      result.result = user_search_result.to_json
      result.save
      result.result
    end

    def user_search_cache_expired?(query)
      cache_entry = TwitterUserSearch.where(query: query).first
      Rails.logger.debug "Checking for cache expiration #{cache_entry.updated_at} - #{Time.zone.now}"
      Time.zone.now - cache_entry.updated_at > 1.hour
    end
  end
end
