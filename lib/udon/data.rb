module Udon
  module Data
    def self.included(klass)
      klass.send :include, MongoMapper::Document
      klass.send :extend, ClassMethods
      klass.send :cattr_accessor, :config
    end

    module ClassMethods
      def text(*args)
        options = args.extract_options!
        key args.first, String
      end

      def checkboxes(*args)
        key args.first, Array
      end

    end
  end
end
