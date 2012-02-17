# ezFAQ plugin migration
# Use rake db:migrate_plugins to migrate installed plugins
#
# Note: Does not preserve history from original ezFaq plugin pre-acts_as_journalized

class CreateInitialJournals < ActiveRecord::Migration
  
  def self.up
    journaled_class = Faq

    say_with_time("Building initial journals for #{journaled_class.class_name}") do
      
      # avoid touching the journaled object on journal creation
      journaled_class.journal_class.class_exec {def touch_journaled_after_creation; end}

      activity_type = journaled_class.activity_provider_options.keys.first

      # Create initial journals
      journaled_class.find(:all).each do |o|
        begin
          o.recreate_initial_journal!
        rescue ActiveRecord::RecordInvalid => e
          puts "ERROR: errors creating the initial journal for #{o.class.to_s}##{o.id.to_s}:" 
          puts "  #{e.message}" 
        end
      end
    end
  end

  def self.down
    # no-op. Data lost, cant be done. bad lack old boy.
  end
end