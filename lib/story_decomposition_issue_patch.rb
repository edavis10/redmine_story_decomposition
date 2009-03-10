require_dependency 'issue'

module StoryDecompositionIssuePatch
  def self.included(base) # :nodoc:
    base.send(:include,InstanceMethods)
  end

  module InstanceMethods
    def save_as_subissue_of(parent_issue, &block)
      Issue.transaction do
        self.project = parent_issue.project
        self.author = User.current
        yield self if block_given?
        issue_saved = self.save

        if issue_saved
          @relation = IssueRelation.new
          @relation.relation_type = IssueRelation::TYPE_COMPOSES
          @relation.issue_from = parent_issue
          @relation.issue_to = self if self.id
          relation_saved = @relation.save
        end
          
        return issue_saved && relation_saved
      end
    end
  end
end

Issue.send(:include, StoryDecompositionIssuePatch)
