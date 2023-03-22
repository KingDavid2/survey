class AddClientToSurvey < ActiveRecord::Migration[7.0]
  def change
    add_reference :surveys, :client, null: false, foreign_key: true, type: :uuid
    add_index :surveys, %i[client_id slug], unique: true
  end
end
