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

    def fields
      @fields ||= [] 
    end

    def [](key)
      fields.find { |f| f.name == key.to_s }
    end

    def submit( text = nil )
      text ||= "Submit"
      FormField.haml( "%input{ :type => 'submit', :value => text }" ).render(nil, {:text => text })
    end

    def form_proxy( source )
      populated = clone
      populated.fields = fields.map do |f|
        field_clone = f.clone
        field_clone.value = source.send f.name
        field_clone
      end
      populated
    end

  end

end
