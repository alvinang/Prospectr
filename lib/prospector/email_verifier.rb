require 'ostruct'
require 'json'

module Prospector
  class EmailVerifier

    def valid?(email)
      if cached?(email) && !cache_expired?(email)
        JSON.parse read_from_cache(email)
      else
        response = perform_validation(email)
        JSON.parse store_in_cache(email, response)
      end
    end

    private

    def perform_validation(email)
      if valid_syntax?(email)
        parse_emailtester_result email
      else
        false
      end
    end

    def cached?(email)
      VerifiedEmails.where(query: email).any?
    end

    def cache_expired?(email)
      cache_entry = VerifiedEmails.where(query: email).first
      Time.zone.now - cache_entry.updated_at > 7.days
    end

    def read_from_cache(email)
      VerifiedEmails.where(query: email).first.response
    end

    def store_in_cache(email, response)
      mail = VerifiedEmails.find_or_initialize_by query: email
      mail.query = email
      mail.response = response.to_json
      mail.save
      mail.response
    end

    def parse_emailtester_result(email_string)
      page = retrieve_emailtester_result(email_string)

      results = '//*[@id="content"]/table'
      row = Nokogiri::HTML(page).xpath(results)[0].css("tr")
      email_recipient  = row[0].text.gsub(/[\s]+/, '')

      mail_server = extract_row_info(row, 2)
      mail_server_identification = extract_row_info(row, 3)
      email_exists = extract_row_info(row, 4)

      result = true
      result &&= mail_server[:valid] if mail_server
      result &&= mail_server_identification[:valid] if mail_server_identification
      result &&= email_exists[:valid] if email_exists

      email_validity = {}
      email_validity[:valid] = result

      email_validity[:mail_server] = mail_server ? mail_server[:value] : nil
      email_validity[:mail_server_valid] = mail_server ? mail_server[:valid] : nil

      email_validity[:mail_server_identification] = mail_server_identification ? mail_server_identification[:value] : nil
      email_validity[:mail_server_identification_valid] = mail_server_identification ? mail_server_identification[:valid] : nil

      email_validity[:email_exists] = email_exists ? email_exists[:value] : nil
      email_validity[:email_exists_valid] = email_exists ? email_exists[:valid] : nil

      email_validity[:email_recipient] = email_recipient

      email_validity
    end


    def retrieve_emailtester_result(email)
      url = "http://mailtester.com/testmail.php"
      agent = Mechanize.new
      agent.user_agent_alias = "Windows Mozilla"
      agent.get url
      form = agent.page.forms[0]
      form["email"] = email
      form.submit

      agent.page.body
    end

    def extract_row_info(row, index)
      begin
        value = extract_text(row, index)
        valid = valid_email_component?(row, index)
        {
            value: value,
            valid: valid
        }
      rescue
        nil
      end
    end

    def extract_text(row, index)
      row[index].css("td")[4].text.to_s.strip
    end

    def valid_email_component?(row, index)
      row[index].css("td")[4].attribute("bgcolor").text.to_s.eql?("#00DD00")
    end

    def valid_syntax?(email_string)
      begin
        email = Mail::Address.new(email_string)
        # We must check that value contains a domain and that value is an email address
        valid = email.domain && email.address == email_string
        tree = email.__send__(:tree)
        # We need to dig into treetop
        # A valid domain must have dot_atom_text elements size > 1
        # user@localhost is excluded
        # treetop must respond to domain
        # We exclude valid email values like <user@localhost.com>
        # Hence we use m.__send__(tree).domain
        valid &&= (tree.domain.dot_atom_text.elements.size > 1)
        valid
      rescue => e
        Rails.logger.error e
        false
      end
    end
  end
end