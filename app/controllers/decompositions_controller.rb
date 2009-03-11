class DecompositionsController < ApplicationController
  class DecompositionException < RuntimeError; end
  
  unloadable
  
  before_filter :find_issue, :except => :new
  before_filter :find_project
  before_filter :authorize
  
  def index
  end
  
  def new
    if params[:new_subissue]
      @child_issue = build_child_issue
      @child_issue.attributes = params[:new_subissue]

      respond_to do |format|
        format.js
      end
    end
  end
  
  def create
    if params[:new_subissue]
      @child_issue = build_child_issue
      successful_save = @child_issue.save_as_subissue_of(current_issue) do |issue|
        issue.attributes = params[:new_subissue]
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
  end

  def find_project
    @project = @issue.project if @issue
    @project ||= Project.find_by_id(params[:project_id])
  end

  def current_issue
    @issue
  end

  def build_child_issue
    Issue.new
  end
end
