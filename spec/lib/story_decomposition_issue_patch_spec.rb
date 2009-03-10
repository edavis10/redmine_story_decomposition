require File.dirname(__FILE__) + '/../spec_helper'

describe Issue, "#save_as_subissue_of" do
  before(:each) do
    @issue_status = mock_model(IssueStatus)
    @priority = mock_model(Enumeration, :opt => 'IPRI')
    @tracker = mock_model(Tracker, :id => 1)
    @project = mock_model(Project, :trackers => [@tracker], :all_issue_custom_fields => [])
    @parent_issue = mock_model(Issue, :project => @project, :project_id => @project.id)

    @current_user = mock_model(User)
    User.stub!(:current).and_return(@current_user)
    @issue = Issue.new(
                       :subject => "Test Issue",
                       :status => @issue_status,
                       :priority => @priority,
                       :tracker => @tracker
                       )
    @issue.stub!(:save).and_return(true)
  end

  it 'should save the issue' do
    @issue.should_receive(:save).and_return(true)
    @issue.save_as_subissue_of(@parent_issue)
  end

  it 'should use the current user as the author' do
    User.should_receive(:current).and_return(@current_user)

    @issue.save_as_subissue_of(@parent_issue) do |issue|
      issue.subject = "Test Issue"
      issue.status = @issue_status
      issue.priority = @priority
      issue.tracker = @tracker
    end

    @issue.author_id.should eql(@current_user.id)
  end

  it 'should allow a block to configure the new issue' do
    @issue.save_as_subissue_of(@parent_issue) do |issue|
      issue.subject = "Test Block"
    end
    @issue.subject.should eql("Test Block")
  end

  it 'should create a new composes Issue Relation' do
    relationship = mock_model(IssueRelation)
    relationship.should_receive(:relation_type=).with(IssueRelation::TYPE_COMPOSES)
    relationship.should_receive(:issue_from=).with(@parent_issue)
    relationship.should_receive(:save).and_return(true)
    IssueRelation.should_receive(:new).and_return(relationship)

    @issue.save_as_subissue_of(@parent_issue)
  end

end

