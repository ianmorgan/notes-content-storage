require 'rubygems'
#require 'sinatra'
require 'sinatra/base'
require 'rack-flash'
require 'erb'
require 'aws-sdk'
require 'json'
require 'date'

require 'yaml'
require 'redcarpet'
require 'stretcher' 
#require 'pygments.rb'
#require 'rubypython'

require File.join(File.dirname(__FILE__), 'modules/helpers')
require File.join(File.dirname(__FILE__), 'modules/string_mixins')
require File.join(File.dirname(__FILE__), 'modules/aws')
require File.join(File.dirname(__FILE__), 'modules/elastic_search')
require File.join(File.dirname(__FILE__), 'modules/config')


class NotesStorageApp < Sinatra::Base
  enable :sessions
  use Rack::Flash  ,  :accessorize => [:notice, :error]
  
  #helpers NotesHelpers
  helpers AWSIntegration
  helpers ElasticSearchIntegration
  helpers ContentStorageConfig
  
  #cache_control :public, :must_revalidate, :no_cache

#helpers NotesHelpers
#RubyPython.start()

  get '/' do
    puts flash
    erb :home
  end

  get '/content/add' do 
    erb :content_add
  end
  
  post '/content/add' do 
    store_content_in_S3(params)
    store_content_in_elastic_search(params) 
    flash[:notice] = "Content has been saved"
    redirect to('/')    
  end
  
  get '/elasticsearch/init' do
    # see https://github.com/PoseBiz/stretcher
    server = Stretcher::Server.new('http://localhost:9200')
    server.index(:directory).delete rescue nil
    server.index(:directory).create(mappings: {doc: {properties: {topic: {type: 'string'}, slug: {type: 'string'}}}})
    #30.times {|t| server.index(:directory).type(:topic).put(t, {topic: "Topic #{t}", slug: 'slug' })}
    
    #puts server.index(:directory).type(:topic).get(3)
    "Directory index created on "
  end
  
  get '/elasticsearch/stats' do
    #puts stats.to_json
    stats["_all"]["primaries"]["docs"].to_json
    #{}"here are the stats"
  end 
  
  get '/elasticsearch/query' do
    query_by_topic 'java'
  end
  
  get '/about' do 
    erb :about
  end

  not_found do
    erb :page_not_found
  end

end