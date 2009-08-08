require 'config/env'
require 'spec/fixtures/subscriptions'

module Udon
  class Application < Sinatra::Base
    configure :development do
      use Sinatra::Reloader, 0
    end

    configure do
      root_dir = File.expand_path(File.dirname(__FILE__))
      set :root,    root_dir
      set :app_file,  File.join(root_dir, 'app.rb')

      enable :logging
    end

    #new
    get '/:collection/new' do
      haml :'new.html', {}, { :current_object => collection_class.new }
    end

    #index
    get '/:collection' do
      haml :'index.html', {}, { :current_objects => collection_class.all, :collection_class => collection_class }
    end

    #update
    put '/:collection/:id' do
      current_object = collection_class.find( params[:id] )
      current_object.attributes = collection_params
      current_object.save
      redirect objects_path
    end

    #destroy
    delete '/:collection/:id' do
      current_object = collection_class.find( params[:id] )
      current_object.destroy
      redirect objects_path
    end

    #edit
    get '/:collection/:id/edit' do
      haml :'edit.html', {}, { :current_object => collection_class.find( params[:id] )}
    end

    #create
    post '/:collection' do
      @current_object = collection_class.new
      @current_object.update_attributes collection_params
      if @current_object.save
        redirect "/#{params[:collection]}", 303
      else
        "FAIL!"
      end
    end

    #sass
    get '/stylesheets/application.css' do
      header 'Content-Type' => 'text/css; charset=utf-8'
      sass :'sass/appliacation'
    end

    helpers FormHelper, RouteHelper, ResourceHelper
  end
end
