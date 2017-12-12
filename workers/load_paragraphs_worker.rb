require_relative 'load_all'

require 'econfig'
require 'shoryuken'
require 'concurrent'

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
    topics = JSON.parse worker_request
    articles = concurrent(topics, WiKey::Wiki::ArticleMapper.new(WiKey::Wiki::Api))
    store_paragraphs(articles)
  end
  
  private
  
  def store_paragraphs(articles)
    articles.each do |article|
      WiKey::Repository::Paragraph.create(article.paragraphs)
    end
  end
  
  def concurrent(inputs, datamapper)
    inputs.map do |input|
      Concurrent::Promise.new { datamapper.get_raw_data(input) }.then {|raw_data| datamapper.build_entity(raw_data)}
    end.map(&:execute).map(&:value)
  end
  
  
end