require 'rails/generators'

module ActionPlugin
  module Generators
    class InstallGenerator <  Rails::Generators::Base
      desc "Create ActionPlugin's action migration file"
      source_root File.expand_path('../../../../db/migrate', __FILE__)

      def add_migration
        current_time = Time.now.strftime("%Y%m%d%H%M%S")
        copy_file "create_actions.rb", "db/migrate/#{current_time}_create_actions.rb"
      end
    end
  end
end
