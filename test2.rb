def syn(inputs)
  inputs.map do |input|
     build_entity(input,get_raw_data(input))
  end
end

def concurrent(inputs)
  m = inputs.size
  n = 1
  promises = inputs.map do |input|
    Concurrent::Promise.new { get_raw_data(input) }.then {|raw_data| build_entity(input,raw_data)}.then{|article| store(article)}.rescue {{error: "#{input} not found."}}
  end
  promises.map do |promise|
    puts n/m.to_f
    n = n + 1
    promise.execute.value
  end
end

def concurrent(inputs)
  inputs.map do |input|
    Concurrent::Promise.new { get_raw_data(input) }.then {|raw_data| build_entity(input,raw_data)}.rescue {{error: "#{input} not found."}}
  end.map(&:execute).map(&:value)
end

def store(article)
  WiKey::Repository::Article.create(article)
end

def build_entity(input, raw_data)
  WiKey::Wiki::ArticleMapper.new(input[:gateway]).build_entity(raw_data)
end

def get_raw_data(input)
  raw_data = input[:gateway].article_data(input[:topic])
  key = raw_data['query']['pages'].keys[0]
  raw_data['query']['pages'][key]
end


Benchmark.bm(10) do |bench|
  bench.report('sync:') { syn(inputs) }
  bench.report('concurrent:') { concurrent(inputs) }
end
