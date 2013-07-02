module Powertools::WhoDidIt
  extend ActiveSupport::Concern

  included do
    belongs_to :creator, class_name: 'User'
    before_create :add_creator

    if self.column_names.include? :updater_id
      belongs_to :updater, class_name: 'User'
      before_update :add_updater
      before_create :add_updater #rails sets updated_at on create so we should also set updater
    end
  end

  private

  def add_creator
    self.creator = User.current if(!self.creator_id && User.current)
    self.creator_id = ENV["SYSTEM_USER_ID"] if(!self.creator_id && ENV["SYSTEM_USER_ID"].present?)
  end

  def add_updater
    self.updater = User.current if User.current
    self.updater_id = ENV["SYSTEM_USER_ID"] if(!self.updater_id && ENV["SYSTEM_USER_ID"].present?)    
  end
end
