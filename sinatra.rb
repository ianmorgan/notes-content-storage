require 'rubygems'
#require 'sinatra'
require 'sinatra/base'
require 'rack-flash'
require 'erb'
require 'aws-sdk'

require 'yaml'
require 'redcarpet'
#require 'pygments.rb'
#require 'rubypython'

require File.join(File.dirname(__FILE__), 'modules/helpers')
require File.join(File.dirname(__FILE__), 'modules/string_mixins')
require File.join(File.dirname(__FILE__), 'modules/aws')


class NotesStorageApp < Sinatra::Base
  enable :sessions
  use Rack::Flash  ,  :accessorize => [:notice, :error]
  
  #helpers NotesHelpers
  helpers AWSIntegration
  
  #cache_control :public, :must_revalidate, :no_cache

#helpers NotesHelpers
#RubyPython.start()

  get '/' do
    puts flash
    erb :home
  end

  get '/test3' do
    cache_control :no_cache
    
    #{}"page 4"
    redirect to('/about') 
  end

  get '/content/add' do 
    erb :content_add
  end

  post '/content/add' do 
    name = params[:title]
    content = params[:content]
    #add_content name, content
    puts "content saved"
    flash[:notice] = "Content has been saved"
    redirect to('/')    
  end

  get '/about' do 
    erb :about
  end

  not_found do
    erb :page_not_found
  end

end