require_relative 'load_all'

require 'econfig'
require 'shoryuken'
require 'concurrent'
require 'http'

class LoadParagraphsWorker
  extend Econfig::Shortcut
  Econfig.env = ENV['RACK_ENV'] || 'development'
  Econfig.root = File.expand_path('..', File.dirname(__FILE__))

  Shoryuken.sqs_client = Aws::SQS::Client.new(
    access_key_id: config.AWS_ACCESS_KEY_ID,
    secret_access_key: config.AWS_SECRET_ACCESS_KEY,
    region: config.AWS_REGION
  )
  
  include Shoryuken::Worker
  shoryuken_options queue: config.P_QUEUE_URL, auto_delete: true
  
  
  def perform(_sqs_msg, worker_request)
    record = JSON.parse worker_request
    topics = JSON.parse record['topics']
    concurrent(topics, WiKey::Wiki::ArticleMapper.new(WiKey::Wiki::Api), record['id'])
  end
  
  private
  
  def store(article)
    WiKey::Repository::Article.create(article)
  end

  def concurrent(inputs, datamapper, channel_id)
    promises = build_promises(inputs, datamapper)
    execute(promises, channel_id)
  end
  
  def build_promises(inputs, datamapper)
    inputs.map do |input|
      Concurrent::Promise.new { datamapper.get_raw_data(input) }
                        .then {|raw_data| datamapper.build_entity(raw_data)}
                        .then{|article| store(article)}.
                        rescue {{error: "#{input} not found."}}
    end
  end
  
  def execute(promises, channel_id)
    m = promises.size
    n = 1
    promises.map do |promise|
      update_progress(channel_id, n/m.to_f)
      n = n + 1
      promise.execute.value
    end
  end
  

  def update_progress(channel_id, percentage)
    percentage = percentage*100
    publish(channel_id, percentage.to_i.to_s)
  end
  
  
  def publish(channel, message)
    puts "Posting progress: #{message} in #{channel}"
    HTTP.headers(content_type: 'application/json').post(
          "https://wikeyapi.herokuapp.com/faye",
          body: {
            channel: "/#{channel}",
            data: message
          }.to_json
        )
  end
  
end