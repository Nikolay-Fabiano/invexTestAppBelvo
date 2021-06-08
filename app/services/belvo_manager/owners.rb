# frozen_string_literal: false

require 'belvo'

module  BelvoManager
  # https://developers.belvo.co/docs/access-your-first-financial-data
  class Owners
    def initialize
      @belvo = Belvo::Client.new(
        Rails.application.credentials.belvo[:secret_id],
        Rails.application.credentials.belvo[:secret_pass],
        'https://sandbox.belvo.co'
      ).owners
    end

    # BelvoManager::Owners.new.listed
    def listed
      @belvo.list
    rescue Belvo::RequestError => e
      puts e.status_code
      puts e.detail
    end

    # BelvoManager::Owners.new.create(data)
    # data example: { id: 9e926ee9-611a-4255-8554-bd730bc0bd2f }
    def create(data)
      @belvo.retrieve(link: data)
    rescue Belvo::RequestError => e
      puts e.status_code
      puts e.detail
    end

    # BelvoManager::Owners.new.get_by_id(data)
    # data example: { id: 9e926ee9-611a-4255-8554-bd730bc0bd2f }
    def get_by_id(data)
      @belvo.detail(id: data)
    rescue Belvo::RequestError => e
      puts e.status_code
      puts e.detail
    end
  end
end
