module Udon
  module Data
    def self.included(klass)
      klass.send :include, MongoMapper::Document
      klass.send :extend, ClassMethods
      klass.send :cattr_accessor, :config
    end

=begin
    def attributes=(values)
      super values.map do |key, val|
        if self.class.config[key].type == :checkboxes
          val.values
        else
          val
        end
      end
    end
=end

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
          Udon::Data.const_set( "Checkbox#{args.first.to_s.classify}", checkbox_mod )
          checkbox_mod.module_eval <<-CHECK
            def #{field_name}=(value)
              super( value.respond_to?( :values ) ? value.values : value )
            end

            def attributes=(values)
              values.stringify_keys!
              if values.has_key?('#{field_name}') && values['#{field_name}'].respond_to?( :values )
                values['#{field_name}'] = values['#{field_name}'].values
              end
              super values
            end
          CHECK
          include checkbox_mod
        end
      end

    end
  end
end
