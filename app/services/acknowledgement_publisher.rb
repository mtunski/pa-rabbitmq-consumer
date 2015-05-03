class AcknowledgementPublisher
  def initialize(currency_id)
    @currency_id, @connection = currency_id, Bunny.new
  end

  def call
    begin
      connection.start
      publish_acknowledgement
    ensure
      connection.stop
    end
  end

  private

  attr_reader :currency_id, :connection

  def publish_acknowledgement
    direct = connection.create_channel.direct('currencies.direct')

    direct.publish({
      id:   ENV['QUEUE_ID'],
      uuid: currency_id
    }.to_json, routing_key: 'acknowledgements')
  end
end

