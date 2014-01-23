class DisplaySelectInput < SimpleForm::Inputs::Base
  # This method usually returns input's html like <input ... />
  #   # but in this case it returns just a value of the attribute.
  def input
    # label code from https://github.com/plataformatec/simple_form/blob/master/lib/simple_form/components/labels.rb#28
    display = object.send(attribute_name)

    if input_options.key? :label_method
      if display.blank?
        output = ""
      elsif input_options.key?(:collection) and input_options[:collection].class.to_s.include?('ActiveRecord')
        obj = input_options[:collection].select { |obj| obj.id==display }.first
        output = input_options[:label_method].call obj
      else
        output = input_options[:label_method].call display
      end
    else
      rel = attribute_name.to_s.gsub(/_id$/, '')
      if object.respond_to?(rel) and object.send(rel).respond_to? :name
        output = object.send(rel).name
      else
        output = display
      end
    end

    template.content_tag(:span, output)
  end

  def additional_classes
    @additional_classes ||= [input_type].compact # original is `[input_type, required_class, readonly_class, disabled_class].compact`
  end
end
