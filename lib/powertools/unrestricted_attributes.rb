module Powertools::UnrestrictedAttributes
  extend ActiveSupport::Concern

  included do
    attr_accessor :unrestricted_attributes
    before_save :save_unrestricted_attributes
  end

  def initialize(*options)
    @unrestricted_attributes = {}
    super(*options)
  end

  def save_unrestricted_attributes
    unless unrestricted_attributes.empty?
      unrestricted_attributes.each do |field, value|
        self[field] = value
      end
    end
  end

  def set_unrestricted_attribute field, value
    self.unrestricted_attributes[field] = value
  end

  def set_unrestricted_attributes *fields
    fields.extract_options!.each do |field, value|
      set_unrestricted_attribute field, value
    end
  end
end
