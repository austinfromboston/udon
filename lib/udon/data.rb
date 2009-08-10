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
        key args.first, File
      end

    end


    unless const_defined? 'CHECKBOX_MODULE_CODE'
      CHECKBOX_MODULE_CODE = <<-CHECK
        def %1$s=(value)
          super( value.respond_to?( :values ) ? value.values : value )
        end

        def attributes=(values)
          values.stringify_keys!
          if values.has_key?('%1$s') && values['%1$s'].respond_to?( :values )
            values['%1$s'] = values['%1$s'].values
          end
          super values
        end
      CHECK
    end
  end
end
