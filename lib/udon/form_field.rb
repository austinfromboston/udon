module Udon
  class FormField

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

    def control
      self.send( "render_#{type}" )
    end

    def plural?
      type.to_s =~ /checkboxes/
    end

    def segments
      return [self] unless plural?
      @segments ||= options[:values].map do |opt|
        FormField.new "#{name}[#{opt.underscore}]", :checkbox, :label => opt
      end

    end

    def id
      "#{type}_#{name}"
    end

    def haml(template)
      self.class.haml(template)
    end

    def self.haml( template )
      @@haml_engine ||= Haml::Engine.new template
      @@haml_engine.send( :initialize, template )
      @@haml_engine
    end



  end
end
