# frozen_string_literal: false

require 'belvo'

module  BelvoManager
  # https://developers.belvo.co/docs/access-your-first-financial-data
  class Balances
    def initialize
      @belvo = Belvo::Client.new(
        Rails.application.credentials.belvo[:secret_id],
        Rails.application.credentials.belvo[:secret_pass],
        'https://sandbox.belvo.co'
      )
    end

    # BelvoManager::Balance.new.listed
    def listed
      @belvo.balances.list
    rescue Belvo::RequestError => e
      puts e.status_code
      puts e.detail
    end

    # BelvoManager::Balance.new.overview
    def overview
      @balances = []
      @belvo.balances.list.each do |current|
        balance = {}
        balance[:category] = current['account']['category']
        balance[:currency] = current['account']['currency']
        balance[:amount] = current['current_balance']
        @balances << balance
      end
      @balances
    end

    # BelvoManager::Balance.new.global
    def global
      @total = {}
      @belvo.balances.list.each do |current|
        key = current['account']['currency']
        @total[key.to_sym] = 0 unless @total.key?(key)
        @total[key.to_sym] += current['current_balance']
      end
      @total
    rescue Belvo::RequestError => e
      puts e.status_code
      puts e.detail
    end

    # BelvoManager::Balance.new.get_by_id(data)
    # data example: { id: 9e926ee9-611a-4255-8554-bd730bc0bd2f }
    def get_by_id(data)
      @belvo.balances.detail(id: data)
    rescue Belvo::RequestError => e
      puts e.status_code
      puts e.detail
    end
  end
end
