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
    if params[:issue] && params[:issue][:new]
      @child_issue = build_child_issue
      successful_save = @child_issue.save_as_subissue_of(current_issue) do |issue|
        issue.attributes = params[:issue][:new]
      end

      respond_to do |format|
        if successful_save
          format.js
        else
          format.js { render :action => :create_error, :status => 500 }
        end
      end
    else
      render :nothing => true
    end
  end
  
private
  def find_issue_and_project
    @issue = Issue.find(params[:id])
    @project = @issue.project
  end

  def current_issue
    @issue
  end

  def build_child_issue
    Issue.new
  end
end
