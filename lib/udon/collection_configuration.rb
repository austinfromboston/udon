require 'haml'
require 'markaby'
require 'udon/form_field'

module Udon
  class CollectionConfiguration
    attr_writer :fields

    def assign(&block)
      instance_eval(&block)
    end

    def text(*args)
      fieldname = args.shift
      options = args.extract_options!
      self.fields.delete_if { |f| f.name == fieldname.to_s }
      self.fields <<  FormField.new( fieldname, :text, options )
    end

    def select(*args)
      fieldname = args.shift
      options = args.extract_options!
      self.fields.delete_if { |f| f.name == fieldname.to_s }
      select_field = FormField.new( fieldname, :select, options )
      select_field.select_options = args.shift
      self.fields << select_field
    end

    def text_area(*args)
      fieldname = args.shift
      options = args.extract_options!
      self.fields.delete_if { |f| f.name == fieldname.to_s }
      self.fields <<  FormField.new( fieldname, :text_area, options )
    end

    def checkboxes(*args)
      fieldname = args.shift
      options = args.extract_options!
      self.fields.delete_if { |f| f.name == fieldname }
      self.fields << FormField.new( fieldname, :checkboxes, options.merge({ :values => args.first }) )
    end

    def file(*args)
      fieldname = args.shift
      options = args.extract_options!
      self.fields.delete_if { |f| f.name == fieldname }
      self.fields << FormField.new( fieldname, :file, options.merge({ :values => args.first }) )
    end

    def fields
      @fields ||= [] 
    end

    def [](key)
      fields.find { |f| f.name == key.to_s }
    end

    def notify(*args); end

    def form_proxy( source )
      populated = clone
      populated.fields = fields.map do |f|
        field_clone = f.clone
        field_clone.value = source.send f.name
        field_clone.errors = !source.errors.on( f.name ).nil?
        field_clone
      end
      populated
    end

    def many( *args )
      association_name = args.first
      options = args.extract_options!
      id_name = "#{association_name.to_s.singularize}_ids"
      checkboxes id_name, lambda { 
          Object.const_get("#{association_name}".classify).all.map { | item | 
            [ item.id, item.name ]
          }
        }, options
    end

    def belongs_to( *args )
      association_name = args.first
      options = args.extract_options!
      id_name = "#{association_name}_id"
      select id_name, lambda { 
          Object.const_get("#{association_name}".classify).all.map { | item | 
            [ item.id, item.name ]
          }
        }, options
    end

    def use_name(*args)
    end

    def wysiwyg(*args)
      options = args.extract_options!
      args << options.merge({:wysiwyg => true})
      text_area *args
    end

  end

end
