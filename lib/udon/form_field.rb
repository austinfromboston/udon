module Udon
  class FormField

    attr_accessor :name, :field_type, :options, :value, :select_options, :errors
    def initialize(name, field_type, options={})
      self.name = name.to_s
      self.field_type = field_type.to_sym
      self.options = options
    end

    def value=(val)
      return @value = val unless plural?
      self.send "#{self.field_type}_value=", val
    end

    def checkboxes_value=(vals)
      segments.each do |seg|
        seg.value = vals && vals.include?( seg.options[:label] ) 
      end
    end

    def label
      ( options[:label] || name.titleize ) unless options[:label] == false
    end

    def plural?
      field_type.to_s =~ /checkboxes/
    end

    def segments
      return [self] unless plural?
      return @segments if @segments
      values = options[:values].is_a?(Proc) ? options[:values].call : options[:values]
      @segments ||= values.map do |opt, opt_label|
        FormField.new "#{name}[#{opt.underscore}]", :checkbox, :label => ( opt_label || opt )
      end

    end

    def required?
      options[:required]
    end

    def errors?
      options[:required]
    end

    def select_options
      return @select_options unless @select_options.is_a? Proc
      @select_options.call
    end

    def html_options
      [ :name, :value, :id, :class ].inject({}) do |html_opts, option_name|
        html_opts[option_name] = options[option_name] if options[option_name]
        html_opts
      end
    end

    def id
      "#{field_type}_#{name}"
    end

  end
end
