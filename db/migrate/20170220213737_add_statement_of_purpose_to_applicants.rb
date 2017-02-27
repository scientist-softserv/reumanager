class AddStatementOfPurposeToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :statement_of_purpose, :text
  end
end
