# frozen_string_literal: false

class StaticPagesController < ApplicationController
  # Dashboard
  def index
    @token = BelvoManager::Widget.new.token
  end

  def single_account
    @account = BelvoManager::Accounts.new.listed.find({ "link": params[:id] })
  end

  def dashboard
    @transactions_dates = {}
    @transactions_dates['date_from'] = Date.today.prev_month.strftime('%Y-%m-%d')
    @transactions_dates['date_to'] = Date.yesterday.strftime('%Y-%m-%d')
    @balances = BelvoManager::Balances.new
    @owners_with_accounts = relate_accounts_with_owners
    @transactions = relate_transactions(@transactions_dates)
    @currencies = format_currencies(@balances.overview)
    @chart_transactions = format_transactions(@transactions)
  end
  # Formats object for charts manipulation
  def format_currencies(value)
    currencies = value.group_by { |k| k[:currency] }
    currencies.each do |cu|
      aux = []
      cu[1].each do |ba|
        aux << ba.except(:currency).values
      end
      cu[1] << { values: aux }
    end
    currencies
  end

  # Formats object for charts manipulation
  def format_transactions(value)
    chart_values = []
    transacts = value.group_by { |k| k['type'] }
    transacts.each do |transact|
      # transact => { "INFLOW" => [{...}, {...}, ...] }
      transact.second.any? ? aux = [transact.first, transact.second.size] : aux = [transact.first, 0]
      chart_values << aux
    end
    chart_values
  end

  # Gets Owners data from each account
  def relate_accounts_with_owners
    accounts = []
    BelvoManager::Accounts.new.listed.each do |account|
      aux = BelvoManager::Owners.new.create(account['link'])
      accounts << aux
    end
    accounts[0]
  end

  # Gets Transactions data from each account
  def relate_transactions(params)
    transactions_list = BelvoManager::Transactions.new
    if transactions_list.listed.empty?
      BelvoManager::Accounts.new.listed.each do |account|
        aux = { 'link': account['link'], 'date_from': params['date_from'], options: { 'date_to': params['date_to'] } }
        transactions_list.create(aux)
      end
    end
    transactions_list.listed
  end
end
