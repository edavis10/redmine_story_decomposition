module ScrumAlliance
  module Redmine
    module VersionMovingExtension
      def self.included(klass)
        klass.class_eval do
          after_save :move_tasks_with_story
        end
      end
      
    private
      def move_tasks_with_story
        return true unless fixed_version_id_changed?
        
        tasks.each do |task|
          task.init_journal(User.current, "Automatically moved with ##{id}")
          task.update_attributes(:fixed_version_id => fixed_version_id)
        end
      end
    end # RankExtension
  end # Redmine
end # ScrumAlliance