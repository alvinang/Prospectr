module Prospector
  class GoogleSearch

    def linked_in(query, description)
      google_query = '"' + description + '" "at '+ query +'" -inurl:/dir/ -inurl:/find/ -inurl:/updates site:linkedin.com'
      Rails.logger.info "Google Query : #{google_query}"

      results = Google::Search::Web.new(query: google_query).collect do |result|
        result
      end

      results
    end

    def google_news(query)
      google_query = "\"#{query}\""

      results = Google::Search::News.new(query: google_query).collect do |result|
        result
      end

      results
    end

  end
end