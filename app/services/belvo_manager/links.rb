# frozen_string_literal: false

require 'belvo'

module  BelvoManager
  # https://developers.belvo.co/docs/test-in-sandbox#create-links-in-sandbox
  class Links
    def initialize
      @belvo = Belvo::Client.new(
        Rails.application.credentials.belvo[:secret_id],
        Rails.application.credentials.belvo[:secret_pass],
        'https://sandbox.belvo.co'
      )
    end

    # BelvoManager::Links.new.listed
    def listed
      @belvo.links.list
    rescue Belvo::RequestError => e
      puts e.status_code
      puts e.detail
    end

    # BelvoManager::Links.new.create(data)
    # Data example: { institution: 'banamex_mx_retail', username: 'dianajaneth', password: 'Ch0coL4t3' }
    def create(data)
      link = @belvo.links.register(data)
      @belvo.accounts.retrieve(link: link['id'])
      @belvo.accounts.list
    rescue Belvo::RequestError => e
      puts e.status_code
      puts e.detail
    end

    # BelvoManager::Links.new.get_by_id(data)
    # Data example: { link_id: d1dbc171-c4b5-4636-a233-3a67d5a9a37f }
    def get_by_id(data)
      @belvo.links.detail(id: data)
    rescue Belvo::RequestError => e
      puts e.status_code
      puts e.detail
    end

    # BelvoManager::Links.new.delete_by_id(data)
    def delete_by_id(data)
      @belvo.links.delete(id: data)
    rescue Belvo::RequestError => e
      puts e.status_code
      puts e.detail
    end
  end
end
