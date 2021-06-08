# frozen_string_literal: false

require 'belvo'

module  BelvoManager
  # https://developers.belvo.co/docs/connect-widget
  class Widget
    def initialize
      @belvo = Belvo::Client.new(
        Rails.application.credentials.belvo[:secret_id],
        Rails.application.credentials.belvo[:secret_pass],
        'https://sandbox.belvo.co'
      )
    end

    # BelvoManager::Widget.new.token
    def token
      @belvo.widget_token.create
    rescue Belvo::RequestError => e
      puts e.status_code
      puts e.detail
    end
  end
end
