module Powertools::UnrestrictedAttributes
  extend ActiveSupport::Concern

  included do
    before_save :save_unrestricted_attributes
  end

  def save_unrestricted_attributes
    if @unrestricted_attributes and @unrestricted_attributes.any?
      @unrestricted_attributes.each do |field, value|
        self.send "#{field}=", value
      end
    end
  end

  def set_unrestricted_attribute field, value
    @unrestricted_attributes ||= {}
    @unrestricted_attributes[field] = value
  end

  def set_unrestricted_attributes *fields
    fields.extract_options!.each do |field, value|
      set_unrestricted_attribute field, value
    end
  end
end
