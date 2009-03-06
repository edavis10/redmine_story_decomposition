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
  it 'should return the parent story for an issue'
  it 'should return nothing if the issue is not a story'
end

describe Issue, 'tasks' do
  it 'should return the child tasks for a story issue'
  it 'should return nothing if the issue is not a story'
end
