class CurrenciesController < ApplicationController
  def index
    @currencies = Currency.all.order('updated_at DESC')
  end
end
