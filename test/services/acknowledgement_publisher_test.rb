require 'test_helper'
require 'mocha/mini_test'
require 'bunny_mock'

class AcknowledgementPublisherTest < ActiveSupport::TestCase
  setup do
    @acknowledgement_publisher = AcknowledgementPublisher.new('uuid')
    stub_rabbitmq_setup
  end

  def test_publishes_acknowledgement_to_proper_queue
    @acknowledgement_publisher.call

    response = ({
      id:   ENV['QUEUE_ID'],
      uuid: 'uuid'
    }).to_json

    assert_equal [response], @acknowledgements_queue.messages
  end

  private

  def stub_rabbitmq_setup
    mock_connection     = BunnyMock.new
    channel             = mock_connection.create_channel

    @acknowledgements_queue = mock_connection.queue("currencies.acknowledgements")
    @acknowledgements_queue.bind(channel.direct('currencies.direct'))

    mock_connection.stubs(:create_channel).returns(channel)
    @acknowledgement_publisher.stubs(:connection).returns(mock_connection)
  end
end
