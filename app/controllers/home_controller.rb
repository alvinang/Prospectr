class HomeController < ApplicationController
  def index

  end

  def linked_in_search
    @query = params[:query]
    google_query = '"description" "'+ @query +'" -inurl:/dir/ -inurl:/find/ -inurl:/updates site:linkedin.com'

    @results = Google::Search::Web.new(query: google_query).collect do |result|
      result
    end

    @results = @results.in_groups_of(10).first

    respond_to do |format|
      format.json {render json: @results.to_json}
    end
  end

  def google_news_feed
    @query = params[:query]
    google_query = "\"#{@query}\""

    @results = Google::Search::News.new(query: google_query).collect do |result|
      result
    end

    @results = @results.in_groups_of(10).first

    respond_to do |format|
      format.json {render json: @results.to_json}
    end
  end

  def twitter_search
    @query = params[:query]
    @results = Twitter.search(@query, lang: "en").results.collect do |result|
      result
    end

    @results = @results.in_groups_of(10).first

    respond_to do |format|
      format.json {render json: @results.to_json}
    end
  end
end
