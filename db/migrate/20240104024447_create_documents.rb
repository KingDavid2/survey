class CreateDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :documents, id: :uuid do |t|
      t.references :client, null: false, foreign_key: true, type: :uuid
      t.string :name

      t.timestamps
    end
  end
end
