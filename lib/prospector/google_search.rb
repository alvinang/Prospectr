module Prospector
  class GoogleSearch

    def linked_in(query, company, name)
      google_query = "\"current * #{query}\" \"at #{company}\" \"#{name}\"  -inurl:/dir/ -inurl:/find/ -inurl:/updates site:linkedin.com"
      search(google_query)
    end

    def search(query)
      Rails.logger.info "Google Query : #{query}"
      results = Google::Search::Web.new(query: query).collect do |result|
        result
      end

      results
    end

    def google_news(*queries)
      google_query = queries.collect do |query|
        "\"#{query}\""
      end

      google_query = google_query.join(" ")

      results = Google::Search::News.new(query: google_query).collect do |result|
        result
      end

      results
    end

  end
end