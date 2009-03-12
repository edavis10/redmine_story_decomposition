require File.dirname(__FILE__) + '/../spec_helper'

describe StoryDecompositionIssueHook, '#controller_issues_new_after_save' do
  describe 'without any subissues' do
    it 'should do nothing' do
      issue = mock_model(Issue)
      issue.should_not_receive(:new)
      StoryDecompositionIssueHook.instance.send(:controller_issues_new_after_save,
                                                {:params => {}, :issue => issue})
    end
  end

  describe 'with subissues' do
    it 'should save each subissue as a subissue of the parent issue' do
      params = {
        :subissue => [
                      {:assigned_to_id => '1', :tracker_id => '1', :subject => 'One'},
                      {:assigned_to_id => '2', :tracker_id => '3', :subject => 'Two'}
                     ]
      }

      project = mock_model(Project)
      issue = mock_model(Issue, :project => project)
      mock_subissue = mock_model(Issue)
      mock_subissue.should_receive(:save_as_subissue_of).with(issue).twice.and_return(true)

      Issue.should_receive(:new).twice.and_return(mock_subissue)
      StoryDecompositionIssueHook.instance.send(:controller_issues_new_after_save,
                                                {:params => params, :issue => issue})
    end
  end
end
