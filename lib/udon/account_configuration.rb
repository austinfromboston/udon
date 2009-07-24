module Udon
  class AccountConfiguration
    @@schemas = {}
    delegate :database, :to => :mongo
    def text
    end

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
      collection

    end
    
    def database=(name)
      mongo.database = db_database_name( name )
    end

    def db_database_name( name )
      "#{name}-#{Sinatra::Application.environment}"
    end
    def db_collection_name( name )
      "#{mongo.database.name}.#{name}"
    end

  end
end
