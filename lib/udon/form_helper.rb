module Udon
  module FormHelper
    def build_form( *args )
      concat form_start_tag( *args )
      yield args.first.class.config.form_proxy(args.first)
      concat "</form>\n"
    end

    def concat(value)
      @haml_buffer.buffer << value
    end

    def form_start_tag(*args)
      options = args.extract_options!
      current_object = args.first
      path = current_object.new_record? ? objects_path : object_path(current_object)
      "<form action='#{path}' method='POST'>\n#{method_override_field( current_object, options )}"
    end

    def method_override_field(current_object, options)
      method = options[:method]
      if !current_object.new_record?
        method ||= :put
      end
      if method && method != :post
        "  <input type='hidden' name='_method' value='#{method.to_s.upcase}'>\n"
      end
    end

    def control_for(field)
      if field.plural?
        field.segments.inject("") do |rendered, field_segment|
          rendered << haml( "controls/#{field_segment.type}.html".to_sym, {}, :field => field_segment )
        end
      else
        haml "controls/#{field.type}.html".to_sym, {}, :field => field
      end
    end

    def submit text
      haml 'controls/submit.html'.to_sym, {}, :text => text
    end

    def field_class field
      class_names = []
      class_names << "required" if field.required?
      class_names << "error" if field.errors?
      class_names.join " "
    end
  end
end
