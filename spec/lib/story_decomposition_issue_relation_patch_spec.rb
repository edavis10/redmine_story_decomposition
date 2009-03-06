require File.dirname(__FILE__) + '/../spec_helper'

describe IssueRelation, "TYPES" do
  it 'should have a "composes" relationship' do
    IssueRelation::TYPES.keys.should include('composes')
  end
end
