module Udon
  class FormField

    attr_accessor :name, :type, :options, :value, :select_options, :errors
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
      ( options[:label] || name.titleize ) unless options[:label] == false
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

    def required?
      options[:required]
    end

    def errors?
      options[:required]
    end


    def html_options
      [ :name, :value, :id, :class ].inject({}) do |html_opts, option_name|
        html_opts[option_name] = options[option_name] if options[option_name]
        html_opts
      end
    end

    def id
      "#{type}_#{name}"
    end

  end
end
