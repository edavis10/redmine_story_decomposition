require_dependency 'issue_relation'

module StoryDecompositionIssueRelationPatch
  TYPE_COMPOSES = 'composes'

  # Adds a composes relationship
  def self.included(base)
    base.class_eval do
      ::IssueRelation::TYPES[TYPE_COMPOSES] = {:name => :label_composes, :sym_name => :label_composed_of, :order => 5}
    end
  end
end

IssueRelation.send(:include, StoryDecompositionIssueRelationPatch)

