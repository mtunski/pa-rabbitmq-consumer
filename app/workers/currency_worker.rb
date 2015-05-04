class CurrencyWorker
  include Sneakers::Worker
  from_queue "currencies.queue_#{ENV['QUEUE_ID']}"

  def work(msg)
    currency = update_or_create_currency(JSON.parse(msg, symbolize_names: true))

    AcknowledgementPublisher.new(currency.id).call && ack!
  end

  private

  def update_or_create_currency(currency_json)
    Currency.find_or_initialize_by(id: currency_json[:uuid]).tap do |currency|
      currency.rates = currency_json[:rates]
      currency.save!
    end
  end
end
