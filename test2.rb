def asyn(input)
  build_entity(input,get_raw_data(input))
end

def concurrent(input)
  Concurrent::Promise.new { get_raw_data(input) }.then {|raw_data| build_entity(input,raw_data)}.rescue{raise StandardError.new("Here comes the Boom!")}.execute
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
  bench.report('sync:') { asyn(input) }
  bench.report('concurrent:') { concurrent(input) }
end