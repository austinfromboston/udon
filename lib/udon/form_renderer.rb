module Udon
  class FormRenderer
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

    def template_label(text)
      "%label{ :for => '#{field_id}'} #{text}"
    end


  end
end
