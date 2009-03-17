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

describe Issue, 'done_ratio for non parent tasks' do
  it 'should use the done_ratio field' do
    issue = Issue.new(:done_ratio => 50)
    issue.should_receive(:tasks).and_return([])
    issue.done_ratio.should eql(50)
  end
end

describe Issue, '#done_ratio for parent tasks' do
  describe 'with estimates' do
    it 'should be the weighted average of the estimates and the child tasks done_ratios' do
      issue = Issue.new
      child_one = mock_model(Issue, :estimated_hours => 10, :done_ratio => 0)
      child_two = mock_model(Issue, :estimated_hours => 90,:done_ratio => 5)

      issue.should_receive(:tasks).at_least(:once).and_return([child_one, child_two])
      issue.done_ratio.should eql(5)

    end
  end

  describe 'without estimates' do
    it 'should be zero' do
      issue = Issue.new
      child_one = mock_model(Issue, :estimated_hours => nil)
      child_two = mock_model(Issue, :estimated_hours => 0)

      issue.should_receive(:tasks).at_least(:once).and_return([child_one, child_two])
      issue.done_ratio.should eql(0)
    end
  end
end
