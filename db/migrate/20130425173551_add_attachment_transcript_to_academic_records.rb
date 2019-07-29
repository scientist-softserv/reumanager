class AddAttachmentTranscriptToAcademicRecords < ActiveRecord::Migration[4.2]
  def self.up
    change_table :academic_records do |t|
      t.attached :transcript
    end
  end

  def self.down
    drop_attached_file :academic_records, :transcript
  end
end
