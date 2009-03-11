class StoryDecompositionIssueHook  < Redmine::Hook::ViewListener
  def view_issues_form_details_bottom(context = { })
    context[:controller].send(:render_to_string, :partial => 'decompositions/list')
  end

  def controller_issues_new_after_save(context = { })
    # TODO: Save subissues to the parent
  end
end
