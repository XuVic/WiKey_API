def syn(inputs)
  inputs.map do |input|
    build_entity(input,get_raw_data(input))
  end
end

def concurrent(inputs)
  inputs.map do |input|
    Concurrent::Promise.new { get_raw_data(input) }.then {|raw_data| build_entity(input,raw_data)}
  end.map(&:execute).map(&:value)
end

def get_raw_data(input)
  raw_data = input[:gateway].article_data(input[:topic])
  key = raw_data['query']['pages'].keys[0]
  raw_data['query']['pages'][key]
end

def build_entity(input, raw_data)
  topic = WiKey::Wiki::TopicMapper.new(input[:gateway]).build_entity(raw_data)
  catalog = WiKey::Wiki::CatalogMapper.new(input[:gateway]).build_entity(raw_data)
  paragraphs = WiKey::Wiki::ParagraphMapper.new(input[:gateway]).build_entity(raw_data)
  article = {:topic => topic, :catalogs => catalog, :paragraphs => paragraphs}
  article
end


Benchmark.bm(10) do |bench|
  bench.report('sync:') { syn(inputs) }
  bench.report('concurrent:') { concurrent(inputs) }
end

require 'aws-sdk-sqs'
config = app.config
sqs = Aws::SQS::Client.new(access_key_id: config.AWS_ACCESS_KEY_ID,
                           secret_access_key: config.AWS_SECRET_ACCESS_KEY,
                           region: config.AWS_REGION)
                           
q_url = sqs.get_queue_url(queue_name: 'demo_queue.fifo').queue_url
queue = Aws::SQS::Queue.new(q_url)

def send_msg(msg, queue)
  msg = {code: msg}
  unique = Time.now
  
  queue.send_message(
    message_body: msg.to_json,
    message_group_id: 'soa_demo',
    message_deduplication_id: 'soa-deom' + unique.hash.to_s
  )
end

message = queue.receive_messages
msg = message.first

queue.delete_messages(
  entries: [
    {
      id: msg.message_id,
      receipt_handle: msg.receipt_handle
    }
  ]
)


def load_multiple(topics, datamapper, n)
  begin
    
  rescue StandardError
  
  end

end