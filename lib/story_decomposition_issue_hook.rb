class StoryDecompositionIssueHook  < Redmine::Hook::ViewListener
  def view_issues_edit_notes_bottom(context = { })
    context[:controller].send(:render_to_string, :partial => 'decompositions/list')
  end
end
