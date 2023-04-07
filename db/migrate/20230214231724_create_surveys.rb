class CreateSurveys < ActiveRecord::Migration[7.0]
  def change
    create_table :surveys, id: :uuid do |t|
      t.string :slug
      t.string :name
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
