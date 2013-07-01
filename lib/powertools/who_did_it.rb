module Powertools::WhoDidIt
  extend ActiveSupport::Concern

  included do
    belongs_to :creator, class_name: 'User'
    before_create :add_creator

    if self.column_names.include? :updater_id
      belongs_to :updater, class_name: 'User'
      before_update :add_updater
    end
  end

  private

  def add_creator
    self.creator = User.current if(!self.creator_id && User.current)
    self.creator_id = ENV["SYSTEM_USER_ID"] if(!self.creator_id && ENV["SYSTEM_USER_ID"].present?)
    if self.column_names.include? :updater_id
      self.updater_id = creator_id #set updater_id too since rails sets updated_at
    end
  end

  def add_updater
    self.updater = User.current if User.current
  end
end
