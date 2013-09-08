module ElasticSearchIntegration 
  
  def server 
    @server ||= Stretcher::Server.new('http://localhost:9200')
  end
  
  def init_indexes
    # see https://github.com/PoseBiz/stretcher
    #server = Stretcher::Server.new('http://localhost:9200')
    server.index(:directory).delete rescue nil
    server.index(:directory).create(mappings: {doc: {properties: {topic: {type: 'string'}, slug: {type: 'string'}}}})
    #30.times {|t| server.index(:directory).type(:topic).put(t, {topic: "Topic #{t}", slug: 'slug' })}
    
  end
  
  def store_content_in_elastic_search(content_hash)
    topic = content_hash[:topic]
    slug = content_hash[:slug]
    server.index(:directory).type(:doc).post({topic: topic, slug: slug} )
  end
  
  def stats
    server.index(:directory).stats
  end
  
  
  def query_by_topic(topic)
    index = server.index(:directory)
    index.msearch([{query: {match_all: {}}}]).to_json
  end

end
