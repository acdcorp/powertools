module Powertools::HistoryTracker
  extend ActiveSupport::Concern

  included do
    if defined? self.has_many
      attr_accessor :pt_changes
      has_many :histories, as: :associated, class_name: 'PtHistory'
      has_many :histories_without_scope, as: :trackable, class_name: 'PtHistory'
      after_update :set_pt_changes
    end
  end

  def set_pt_changes
    if self.changed?
      ignore_list     = %w(created_at updated_at deleted_at)
      self.pt_changes = changes.reject { |key, value| ignore_list.include? key }
    else
      false
    end
  end

  def pt_track_history(trackable, options = {})
    raise "Must pass current user" if options[:current_user].blank?
    # So we can access it via a string or symbol
    options = options.with_indifferent_access

    # Set the current action
    action = options.key?(:action) ? options[:action] : params[:action]

    # Go no further if we don't have updates
    return if (action == 'update' and not trackable.pt_changes)

    # Set the current history user
    if options.key? :current_user
      history_current_user = options[:current_user]
    else
      history_current_user = current_user
    end

    # Create the new history line
    history = history_current_user.histories.new action: action

    history.action     = action
    history.trackable  = trackable
    history.associated = options.key?(:scope) ? options[:scope] : trackable

    if action == 'update'
      history.trackable_changes = trackable.pt_changes.to_json
    end

    # Save any extra options
    if options.key? :extras
      history.extras = extras
    end

    # Save the history
    history.save!
  end unless defined? self.has_many
end
