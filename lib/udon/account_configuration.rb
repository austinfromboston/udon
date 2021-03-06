require 'ostruct'
module Udon
  class AccountConfiguration
    @@schemas = {}
    delegate :database, :to => :mongo
    attr_accessor :services
    
    def mongo
      MongoMapper
    end
    
    def collection(name=nil, &block )
      collection = database.collection( name )
      return collection unless block_given?
      collection_class_name = name.to_s.classify
      if !Object.const_defined? collection_class_name
        collection_class = Class.new do
          include Udon::Data
        end
        Object.const_set name.to_s.classify, collection_class
      else
        collection_class = Object.const_get collection_class_name
      end
      collection_class.instance_eval(&block)
      collection_class.config = Udon::CollectionConfiguration.new
      collection_class.config.assign(&block)
      initialize_validations collection_class
      collection

    end

    def initialize_validations(collection_class)
      collection_class.config.fields.each do |field|
        next unless field.required?
        collection_class.instance_eval "validates_presence_of :#{field.name}" rescue ArgumentError
      end

    end
    
    def database=(name)
      mongo.database = db_database_name( name )
    end

    def db_database_name( name )
      "#{name}-#{Sinatra::Application.environment}"
    end

    def db_collection_name( name )
      "#{name}"
      #"#{mongo.database.name}.#{name}"
    end

    def service( service_name, &blk )
      if self.services[service_name].nil? || blk
        service_instance = self.send "load_service_#{service_name}", &blk
      end
      self.services[service_name] ||= service_instance
    end

    def services
      @services ||= {}
    end

    def load_service_democracy_in_action &blk
      if block_given?
        config = OpenStruct.new
        yield config
      end
      # passing an argument to node below prevents a very odd error in cucumber
      DemocracyInAction::API.new( {}, config.login, config.password, config.node(true) )
    end

  end
end
