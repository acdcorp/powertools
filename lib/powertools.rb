class String
  def is_i?
    !!(self =~ /^[-+]?[0-9]+$/)
  end
end

# class String
#   def is_number?
#     true if Float(self) rescue false
#   end
# end

class String
  def to_boolean
    return true if self == true || self =~ (/(true|t|yes|y|1)$/i)
    return false if self == false || self.blank? || self =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end
end

require 'hooks'
if defined? Rails
  require 'powertools/engine'
  require 'powertools/form'
  require 'powertools/form_input'
  require 'powertools/nav'
  require 'powertools/respond_to'
  require 'powertools/current_user'
  require 'powertools/who_did_it'
  require 'powertools/ajax_flash'
  require 'powertools/unrestricted_attributes'
  require 'powertools/generators/history_tracker_generator'
end
require 'powertools/history_tracker'
module Powertools
end
