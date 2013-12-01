class DisplayInput < SimpleForm::Inputs::Base
  # This method usually returns input's html like <input ... />
  #   # but in this case it returns just a value of the attribute.
  def input
    # label code from https://github.com/plataformatec/simple_form/blob/master/lib/simple_form/components/labels.rb#28
    display = object.send(attribute_name)

    if display.is_a?(String)
      if display.class == Enumerize::Value
        output = display.text
      else
        output = display
      end
    elsif !!display == display ##check if boolean
      output = display ? "Yes" : "No"
    else
      output = display
    end

    template.content_tag(:span, output)
  end

  def additional_classes
    @additional_classes ||= [input_type].compact # original is `[input_type, required_class, readonly_class, disabled_class].compact`
  end
end
