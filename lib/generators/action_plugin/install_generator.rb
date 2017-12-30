require 'rails/generators'
require 'rails/generators/migration'

module ActionPlugin
  module Generators
    class InstallGenerator <  Rails::Generators::NamedBase
      desc "Create ActionPlugin's action migration file"

      argument :name, type: :string, default: 'actions'
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)

      def self.next_migration_number(dirname)
        if ActiveRecord::Base.timestamped_migrations
          [Time.now.utc.strftime("%Y%m%d%H%M%S"), "%.14d"].max
        else
          SchemaMigration.normalize_migration_number(dirname)
        end
      end

      def create_action
        migration_template 'migration.rb', 'db/migrate/create_actions.rb', migration_version: migration_version
      end

      def rails5?
        Rails.version.start_with? '5'
      end

      def migration_version
        "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]" if rails5?
      end

    end
  end
end
