# frozen_string_literal: false

require 'belvo'

module  BelvoManager
  # https://developers.belvo.co/docs/access-your-first-financial-data
  class Transactions
    def initialize
      @belvo = Belvo::Client.new(
        Rails.application.credentials.belvo[:secret_id],
        Rails.application.credentials.belvo[:secret_pass],
        'https://sandbox.belvo.co'
      )
    end

    # BelvoManager::Transactions.new.listed
    def listed
      @belvo.transactions.list
    rescue Belvo::RequestError => e
      puts e.status_code
      puts e.detail
    end

    # BelvoManager::Transactions.new.create(data)
    # data example: { link: 9e926ee9-611a-4255-8554-bd730bc0bd2f, date_from: '2010-02-02', date_to: '2020-02-10' }
    def create(data)
      @belvo.transactions.retrieve(data)
    rescue Belvo::RequestError => e
      puts e.status_code
      puts e.detail
    end

    # BelvoManager::Transactions.new.get_by_id(data)
    # data example: { id: 9e926ee9-611a-4255-8554-bd730bc0bd2f }
    def get_by_id(data)
      @belvo.transactions.detail(id: data)
    rescue Belvo::RequestError => e
      puts e.status_code
      puts e.detail
    end
  end
end
