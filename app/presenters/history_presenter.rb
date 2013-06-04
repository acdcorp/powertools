class HistoryPresenter < BasePresenter
  def render_history
    div_for @object do
      @object.creator.full_name + " " + render_partial
    end
  end

  def render_partial
    locals = {history: history, presenter: self}
    locals[activity.trackable_type.underscore.to_sym] = @object.trackable
    render partial_path, locals
  end

  def partial_path
    partial_paths.detect do |path|
      lookup_context.template_exists? path, nil, true
    end || raise("No partial found for activity in #{partial_paths}")
  end

  def partial_paths
    [
      "history/#{@object.trackable_type.underscore}/#{@object.action}",
      "history/#{@object.trackable_type.underscore}",
      "history/default"
    ]
  end
end
