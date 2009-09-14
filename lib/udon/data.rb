module Udon
  module Data
    def self.included(klass)
      klass.send :include, MongoMapper::Document
      klass.send :include, MongoMapperOverrides
      klass.send :extend, ClassMethods
      klass.send :cattr_accessor, :config, :services
    end


    module ClassMethods
      def text(*args)
        options = args.extract_options!
        key args.first, String
      end

      def select(*args)
        key args.first, String
      end

      def text_area(*args)
        key args.first, String
      end

      def checkboxes(*args)
        field_name = args.first
        key field_name, Array
        module_name = "Checkbox#{args.first.to_s.classify}"
        if Udon::Data.const_defined?( module_name )
          include Udon::Data.const_get( module_name )
        else
          checkbox_mod = Module.new
          Udon::Data.const_set( module_name, checkbox_mod )
          checkbox_mod.module_eval( CHECKBOX_MODULE_CODE % field_name, __FILE__, __LINE__ )
          include checkbox_mod
        end
      end

      def file(*args)
        mount_uploader args.first, Udon::FileUploader
      end


      def notify( *args )
        options = args.extract_options!
        service_name = args.first
        service = Udon::Services.const_get("#{service_name}".classify)
        self.services ||= {}
        self.services[:democracy_in_action] ||= []
        self.services[:democracy_in_action] << service.new( self, options )
      end
    
      
      

    end


    unless const_defined? 'CHECKBOX_MODULE_CODE'
      CHECKBOX_MODULE_CODE = <<-end_eval
        def %1$s=(value)
          super( value.respond_to?( :values ) ? value.values : value )
        end
      end_eval
    end



    module MongoMapperOverrides
      def ensure_key_exists(name)
        raise NoMethodError unless respond_to? "#{name}"
        super
      end

    end
  end
end
