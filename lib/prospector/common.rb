module Prospector
  module Common
    def cached?(query)
      search_db(query).any?
    end

    def read_from_cache(query)
      search_db(query).first.result
    end

    def cache_result_in_db(query, search_result)
      Rails.logger.debug "Caching in database the user search for #{query} : #{search_result.to_json}"
      cache_entry = create_db_entry(query)
      cache_entry.result = search_result.to_json
      cache_entry.save
      cache_entry.result
    end

    def cache_expired?(query)
      cache_entry = search_db(query).first
      Rails.logger.debug "Checking for cache expiration #{cache_entry.updated_at} - #{Time.zone.now}"
      Time.zone.now - cache_entry.updated_at > 1.hour
    end

    def search_and_cache(query)
      result = fetch_from_twitter query
      cache_result_in_db query, result
    end

    def fetch_content(query)
      if cached?(query) and not cache_expired?(query)
        Rails.logger.debug "Returning cached response to search for user #{query}"
        read_from_cache(query)
      else
        Rails.logger.debug "Not in cache or cache expired. Using twitter client to search for user #{query}"
        search_and_cache(query)
      end
    end
  end
end