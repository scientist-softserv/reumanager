class ChangeApplicantStatusDefault < ActiveRecord::Migration[5.2]
  def change
    change_column_default :applicants, :state, from: nil, to: 'started'
  end
end
