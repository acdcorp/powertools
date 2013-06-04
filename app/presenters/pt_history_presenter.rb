class PtHistoryPresenter < PtBasePresenter
  def render
    @template.div_for @object do
      template.link_to(@object.creator.full_name, @object.creator) + " " + render_partial
    end
  end

  def render_partial
    locals = {history: object, presenter: self}
    locals[object.trackable_type.underscore.to_sym] = @object.trackable
    template.render partial_path, locals
  end

  def partial_path
    partial_paths.detect do |path|
      template.lookup_context.template_exists? path, nil, true
    end || raise("No partial found for activity in #{partial_paths}")
  end

  def partial_paths
    [
      "histories/#{@object.trackable_type.underscore.pluralize}/#{@object.action}",
      "histories/#{@object.trackable_type.underscore.pluralize}",
      "histories/default"
    ]
  end
end
