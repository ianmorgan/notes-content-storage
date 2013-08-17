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

  get '/content/add' do 
    erb :content_add
  end

  post '/content/add' do 
    add_content params 
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