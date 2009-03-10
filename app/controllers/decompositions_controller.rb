class DecompositionsController < ApplicationController
  class DecompositionException < RuntimeError; end
  
  unloadable
  
  before_filter :find_issue_and_project, :authorize
  
  def index
  end
  
  def new
    render :partial => 'issue', :object => Issue.new(:project => @project)
  end
  
  def create
    if params[:issue][:new]
      @issue = Issue.new(params[:issue][:new])
      @issue.project = @project
      @issue.author = User.current

      @parent_issue = Issue.find(params[:id])
      @relation = IssueRelation.new(:relation_type => IssueRelation::TYPE_COMPOSES)
      @relation.issue_from_id = @parent_issue.id

      respond_to do |format|
        Issue.transaction do
          begin
            @issue.save!
            @relation.issue_to_id = @issue.id
            @relation.save!
            format.js
          rescue ActiveRecord::RecordInvalid
            format.js { render :action => :create_error }
          end
        end
      end # respond_to
    end
  end
  
private
  def find_issue_and_project
    @issue = Issue.find(params[:id])
    @project = @issue.project
  end
end
