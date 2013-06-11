require 'ostruct'

class HomeController < ApplicationController
  before_filter :authenticate_user!

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

    respond_to do |format|
      format.json { render json: @results.to_json }
    end
  end

  def twitter_search
    @query = params[:query]
    @users = twitter_client.user_search @query

    logger.debug @users

    respond_to do |format|
      format.json { render json: @users }
    end
  end

  def twitter_timeline_search
    @screen_name = params[:screen_name]

    begin
      @tweets = twitter_client.user_timeline(@screen_name)
    rescue Twitter::Error::Unauthorized
      @error = "Tweets are not made public. Please visit Twitter to find out more."
    end

    respond_to do |format|
      if @error
        format.json { render json: {error: @error}, :status => 403 }
      else
        format.json { render json: @tweets }
      end
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

  def email_verifier
    @email = params[:email]

    result = email_verifier_client.valid? @email

    if result
      @valid = result['valid']
    else
      @valid = false
    end

    respond_to do |format|
      if @valid
        format.json { render json: {}, :status => 200 }
      else
        format.json { render json: {}, :status => 404 }
      end

    end
  end

  private

  def email_verifier_client
    @email_verifier ||= Prospector::EmailVerifier.new
  end

  def twitter_client
    @twitter_client ||= Prospector::TwitterCachingClient.new
  end
end
