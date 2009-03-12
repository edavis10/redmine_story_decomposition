class StoryDecompositionIssueHook  < Redmine::Hook::ViewListener
  def view_issues_form_details_bottom(context = { })
    context[:controller].send(:render_to_string, :partial => 'decompositions/list')
  end

  def controller_issues_new_after_save(context = { })
    if context[:params] && context[:params][:subissue] && context[:issue]
      context[:params][:subissue].each do |subissue_params|
        @child_issue = Issue.new
        @child_issue.save_as_subissue_of(context[:issue]) do |issue|
          issue.attributes = subissue_params
        end
      end
    end

    return ''
  end
end
