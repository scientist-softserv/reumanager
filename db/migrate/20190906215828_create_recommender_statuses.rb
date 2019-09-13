class CreateRecommenderStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :recommender_statuses do |t|
      t.string :email
      t.timestamp :last_sent_at
      t.timestamp :submitted_at
      t.references :applicant, foreign_key: true

      t.timestamps
    end
  end
end
