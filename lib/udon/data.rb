module Udon
  module Data
    def self.included(klass)
      klass.send :include, MongoMapper::Document
      klass.send :include, MongoMapperOverrides
      klass.send :extend, ClassMethods
      klass.send :cattr_accessor, :config
      klass.send :cattr_accessor, :name_field
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
        checkboxes_filter field_name
      end

      def checkboxes_filter(field_name)
        module_name = "Checkbox#{field_name.to_s.classify}"
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

      def wysiwyg(*args)
        text_area *args
      end

      def notify( *args )
        options = args.extract_options!
        service_name = args.first
        service = Udon::Services.const_get("#{service_name}".classify)
        new_service = service.new( self, options )
        if new_service.active?
          self.services[service_name.to_sym] ||= []
          self.services[service_name.to_sym] << service.new( self, options ) 
        end
      end

      def services
        @@services ||= {}
      end

      def many(*args)
        association_name = args.first
        id_name = "#{association_name.to_s.singularize}_ids"
        key id_name
        checkboxes_filter id_name
        super
      end

      def belongs_to(*args)
        association_name = args.first
        id_name = "#{association_name}_id"
        key id_name
        super
      end

      def use_name(*args)
        self.name_field = args.first
      end
      
      

    end

    def name
      self.class.name_field ||= :name
      if self.class.keys.include?( self.class.name_field )
        return read_attribute( self.class.name_field )
      end
      "name unknown"
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
