require 'haml'

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
      self.fields <<  CollectionField.new( fieldname, :text, options )
    end

    def checkboxes(*args)
      fieldname = args.shift
      options = args.extract_options!
      self.fields.delete_if { |f| f.name == fieldname }
      self.fields << CollectionField.new( fieldname, :checkboxes, options.merge({ :values => args.first }) )
    end

    def fields
      @fields ||= [] 
    end

    def [](key)
      fields.find { |f| f.name == key.to_s }
    end

    def submit( text = nil )
      text ||= "Submit"
      CollectionField.haml "%input{ :type => 'submit', :value => '#{text}'}"
    end

  end

  class CollectionField

    attr_accessor :name, :type, :options
    def initialize(name, type, options={})
      self.name = name.to_s
      self.type = type.to_sym
      self.options = options
    end

    def label
      label_text = name.titleize
      if options.has_key? :label
        return unless options[:label]
        label_text = options[:label]
      end
      haml template_label(label_text)
    end

    def control
      haml self.send( "template_#{type}" )
    end

    def haml(template)
      self.class.haml(template)
    end

    def self.haml( template )
      @@haml_engine ||= Haml::Engine.new template
      @@haml_engine.send( :initialize, template )
      @@haml_engine.to_html
    end

    def template_text 
      "%input{ :name => '#{name}'}"
    end

    def template_checkbox
      "%input{ :name => '#{name}', :type => 'checkbox', :value => 1 }"
    end

    def template_label(text)
      "%label{ :for => '#{name}'} #{text}"
    end



    def plural?
      type.to_s =~ /checkboxes/
    end

    def segments
      return [self] unless plural?
      options[:values].map do |opt|
        CollectionField.new "#{name}[#{opt.underscore}]", :checkbox, :label => opt
      end

    end
  end
end
