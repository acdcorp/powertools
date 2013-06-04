require 'rails/generators'
require File.expand_path('../utils', __FILE__)

module PowerTools
  class HistoryTrackerGenerator < Rails::Generators::Base
    include Rails::Generators::Migration
    include Generators::Utils::InstanceMethods
    extend Generators::Utils::ClassMethods
    source_root File.expand_path('../templates', __FILE__)

    desc "PowerTools History Tracker Install"

    def history_trackere
      display "Installing PowerTools Histories Migration"
      migration_template 'histories_migration.rb', 'db/migrate/create_pt_histories_table.rb' rescue display $!.message
      display "Please run rake db:migrate"
      display "Adding History Model"
      template "pt_history.rb", "app/models/pt_history.rb"
      display "finished"
    end
  end
end
