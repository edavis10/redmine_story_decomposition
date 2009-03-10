require File.dirname(__FILE__) + '/../../../spec_helper'

describe Issue, 'story?' do
  it 'should be true if the issue uses the "Story" tracker' do
    issue = Issue.new(:tracker => mock_model(Tracker, :name => "Story"))
    issue.story?.should be_true
  end

  it 'should be true if the issue uses the "story" tracker' do
    issue = Issue.new(:tracker => mock_model(Tracker, :name => "story"))
    issue.story?.should be_true
  end

  it 'should be false if the issue uses any other tracker' do
    issue = Issue.new(:tracker => mock_model(Tracker, :name => "Bug"))
    issue.story?.should be_false
  end
end

describe Issue, 'story' do
  it 'should return the parent story for an issue' do
    parent_issue = mock_model(Issue)
    child_issue = Issue.new
    child_issue.should_receive(:relations_to).and_return do
      relation = mock_model(IssueRelation)
      relation.should_receive(:relation_type).and_return('composes')
      relation.should_receive(:issue_from).and_return(parent_issue)
      
      [relation]
    end

    child_issue.story.should eql(parent_issue)
  end
end

describe Issue, 'tasks' do
  it 'should return the child tasks for a story issue' do
    child_issue_one = mock_model(Issue)
    child_issue_two = mock_model(Issue)
    child_issue_three = mock_model(Issue)
    children = [child_issue_one, child_issue_two, child_issue_three]
    parent_issue = Issue.new
    parent_issue.should_receive(:relations_from).and_return do
      relations = []
      children.each do |child_issue|
        relation = mock_model(IssueRelation)
        relation.should_receive(:relation_type).and_return('composes')
        relation.should_receive(:issue_to).and_return(child_issue)
        relations << relation
      end
      relations
    end

    parent_issue.tasks.should eql(children)
    
  end
end
