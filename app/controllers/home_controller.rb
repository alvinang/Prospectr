require 'ostruct'

class HomeController < ApplicationController
  def index

  end

  def linked_in_search
    @query = params[:query]
    @description = ""

    if params[:description].present?
      @description = params[:description]
    end

    google_query = '"' + @description + '" "at '+ @query +'" -inurl:/dir/ -inurl:/find/ -inurl:/updates site:linkedin.com'

    logger.info "Google Query : #{google_query}"

    @results = Google::Search::Web.new(query: google_query).collect do |result|
      result
    end

    @results = @results.in_groups_of(10).first

    respond_to do |format|
      format.json { render json: @results.to_json }
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
      format.json { render json: @results.to_json }
    end
  end

  def twitter_search
    @query = params[:query]
    @users = Twitter.user_search(@query, lang: "en")

    respond_to do |format|
      format.json { render json: @users.to_json }
    end
  end

  def twitter_timeline_search
    Twitter.connection_options = {:timeout => 30, :open_timeout => 2}

    @screen_name = params[:screen_name]
    @tweets = Twitter.user_timeline(@screen_name)

    respond_to do |format|
      format.json { render json: @tweets.to_json }
    end
  end

  def email_format_search
    @query = params[:query]
    url = "http://www.email-format.com/d/#{@query}"
    email_regex = /([0-9a-zA-Z]([-\.\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\w]*[0-9a-zA-Z]\.)+[a-zA-Z]{2,9})/

    mechanize = Mechanize.new
    page = mechanize.get url

    @results = []

    document = Nokogiri::HTML page.body
    document.css("#domain_adress_container .li_email").each do |li|
      @results << li.content.match(email_regex)[0]
    end

    respond_to do |format|
      format.json { render json: @results.to_json }
    end
  end


end
