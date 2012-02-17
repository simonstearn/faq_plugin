# ezFAQ plugin migration
# Use rake db:migrate_plugins to migrate installed plugins
class ResumeDefaultLockingColumn < ActiveRecord::Migration
  def self.up
    rename_column :faqs, :version, :lock_version
  end

  def self.down
    rename_column :faqs, :lock_version, :version
  end
end
