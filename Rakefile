#!/usr/bin/env ruby
require 'rake'
#require '/home/edavis/dev/redmine/plugins/redmine_plugin_support/lib/redmine_plugin_support'
require 'redmine_plugin_support'

Dir[File.expand_path(File.dirname(__FILE__)) + "/lib/tasks/**/*.rake"].sort.each { |ext| load ext }

RedminePluginSupport::Base.setup(
                                 :project_name => 'redmine_story_decomposition',
                                 :default => [:spec]
                                 )

