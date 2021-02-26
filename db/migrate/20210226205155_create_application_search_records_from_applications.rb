class CreateApplicationSearchRecordsFromApplications < ActiveRecord::Migration[5.2]
  def up
    Application.find_each(&:update_application_search_record)
  end

  def down
    ApplicationSearchRecord.destroy_all
  end
end
