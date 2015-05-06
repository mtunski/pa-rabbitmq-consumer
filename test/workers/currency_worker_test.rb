require 'test_helper'
require 'mocha/mini_test'

class CurrencyWorkerTest < ActiveSupport::TestCase
  setup do
    @currency_worker = CurrencyWorker.new
    AcknowledgementPublisher.any_instance.stubs(:call).returns(true)
  end

  def test_creates_new_currency_if_not_already_in_the_db
    assert_difference 'Currency.count' do
      @currency_worker.work({ id: 'uuid', rates: { eur: 1 } }.to_json)
    end
  end

  def test_does_not_create_new_currency_if_already_in_the_db
    currency = Currency.create!(id: 'uuid', rates: { eur: 666 })

    assert_no_difference 'Currency.count' do
      @currency_worker.work({ id: 'uuid', rates: { eur: 1 } }.to_json)
    end

    currency.reload

    assert_equal ({ 'eur' => 1 }), currency.rates
  end

  def test_acks_when_successful
    @currency_worker.expects(:ack!).once

    @currency_worker.work({ id: 'uuid', rates: { eur: 1 } }.to_json)
  end
end
