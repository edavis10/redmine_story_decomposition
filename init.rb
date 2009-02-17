require 'redmine'

require_dependency 'scrum_alliance/redmine/story_task_extensions'
require_dependency 'scrum_alliance/redmine/version_moving_extension'

require 'dispatcher'
Dispatcher.to_prepare do
  Issue.class_eval { include ScrumAlliance::Redmine::VersionMovingExtension }
  Issue.class_eval { include ScrumAlliance::Redmine::StoryTaskExtensions }
end

Redmine::Plugin.register :redmine_story_decomposition do
  name 'Redmine Story Decomposition plugin'
  author 'Dan Hodos'
  description 'Creates a UI for decomposing stories into tasks. Also makes sure tasks move with their stories when a Version is assigned'
  version '0.0.1'
  
  permission :decompose_story, { :decompositions => [:index, :new, :create] }, :public => true
end
