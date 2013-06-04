class FakeInput < SimpleForm::Inputs::Base
  # This method usually returns input's html like <input ... />
  # but in this case it returns just a value of the attribute.
  def input
    return input_html_options[:value] if input_html_options[:value].present?
    object.send(attribute_name)
  end
end
