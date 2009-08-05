require 'haml'
require 'markaby'

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

    def select(*args)
      fieldname = args.shift
      options = args.extract_options!
      self.fields.delete_if { |f| f.name == fieldname.to_s }
      self.fields <<  CollectionField.new( fieldname, :select, options )
    end

    def text_area(*args)
      fieldname = args.shift
      options = args.extract_options!
      self.fields.delete_if { |f| f.name == fieldname.to_s }
      self.fields <<  CollectionField.new( fieldname, :text_area, options )
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
      CollectionField.haml( "%input{ :type => 'submit', :value => text }" ).render(nil, {:text => text })
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

  class CollectionField

    attr_accessor :name, :type, :options, :value
    def initialize(name, type, options={})
      self.name = name.to_s
      self.type = type.to_sym
      self.options = options
    end

    def value=(val)
      return @value = val unless plural?
      self.send "#{self.type}_value=", val
    end

    def checkboxes_value=(vals)
      segments.each do |seg|
        seg.value = vals.include? seg.options[:label]
      end
    end

    def label
      @label_text = name.titleize
      if options.has_key? :label
        return unless options[:label]
        @label_text = options[:label]
      end
      template = "%label{ :for => field_id }=@label_text"
      haml(template).render self
    end

    def template_vars
      { :name => name, :field_id => field_id, :value => value, :options => options }
    end

    def control
      self.send( "render_#{type}" )
    end

    def haml(template)
      self.class.haml(template)
    end

    def self.haml( template )
      @@haml_engine ||= Haml::Engine.new template
      @@haml_engine.send( :initialize, template )
      @@haml_engine
    end

    def render_text
        
      template = "%input{ :name => name, :value => value }"
      haml(template).render(self)
    end

    def render_text_area
      template = 
        "%textarea{ :name => name}\n" +
        "  ~ value"
      haml(template).render(self)
    end

    def render_select
      template = "%select{ :name => name}"
      haml(template).render(self)
    end

    def render_checkbox
      template = 
        "%input{ :name => name, :type => 'hidden' }\n" +
        "%input{ {:id => field_id, :name => name, :type => 'checkbox', :value => options[:label] }.merge( value ? { :checked => 'checked' } : {} )}"
      haml(template).render(self)
    end

    def field_id
      "#{type}_#{name}"
    end

    def template_label(text)
      "%label{ :for => '#{field_id}'} #{text}"
    end



    def plural?
      type.to_s =~ /checkboxes/
    end

    def segments
      return [self] unless plural?
      @segments ||= options[:values].map do |opt|
        CollectionField.new "#{name}[#{opt.underscore}]", :checkbox, :label => opt
      end

    end
  end
end
