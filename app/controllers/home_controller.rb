require 'ostruct'

class HomeController < ApplicationController

  before_filter :authenticate_user!
  before_action :parse_params

  def index
  end

  def linked_in_search
    @results = google_search_client.linked_in @query, @description, @name

    respond_to do |format|
      format.json { render json: @results.to_json }
    end
  end

  def google_news_feed
    @query = params[:query]

    @results = google_search_client.google_news @query, @description, @name

    respond_to do |format|
      format.json { render json: @results.to_json }
    end
  end

  def google_search
    @query = params[:query]

    @results = google_search_client.search @query

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

  def parse_params
    @query = ""
    @description = ""
    @name = ""

    if params[:query].present?
      @query = params[:query]
    end

    if params[:description].present?
      @description = params[:description]
    end

    if params[:name].present?
      @name = params[:name]
    end
  end

  def email_verifier_client
    @email_verifier ||= Prospector::EmailVerifier.new
  end

  def twitter_client
    @twitter_client ||= Prospector::TwitterCachingClient.new
  end

  def google_search_client
    @google_search_client ||= Prospector::GoogleSearch.new
  end
end
