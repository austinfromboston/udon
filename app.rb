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

    get '/:collection/new' do
      haml :'new.html', {}, { :current_object => collection_class.new }
    end

    put '/:collection/:id' do
    end

    post '/:collection' do
      @current_object = collection_class.new
      @current_object.update_attributes collection_params
      if @current_object.save
        "SAVED!"
      else
        "FAIL!"
      end
    end

    get '/stylesheets/application.css' do
      header 'Content-Type' => 'text/css; charset=utf-8'
      sass :'sass/appliacation'
    end

    helpers do
      def build_form(source)
        ( yield source.class.config )
      end

      def objects_path
        "/#{params[:collection]}"
      end

      def collection_class
        @klass ||= Object.const_get params[:collection].classify
      end

      def collection_params
        params.dup.delete_if { |key, item| key == :collection }
      end
    end
  end
end
