class CreateAttempts < ActiveRecord::Migration[7.0]
  def change
    create_table :attempts, id: :uuid do |t|
      t.references :survey, null: false, foreign_key: true, type: :uuid
      t.boolean :completed, null: false, default: false

      t.timestamps
    end
  end
end
