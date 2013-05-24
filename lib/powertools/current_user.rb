module Powertools::CurrentUser
  extend ActiveSupport::Concern

  ## Allows you to access the current user anywhere including models or observers
  module ClassMethods
    def current
      Thread.current[:user]
    end

    def current=(user)
      Thread.current[:user] = user
    end
  end
end
