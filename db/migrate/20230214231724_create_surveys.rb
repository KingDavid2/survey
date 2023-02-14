class CreateSurveys < ActiveRecord::Migration[7.0]
  def change
    create_table :surveys, id: :uuid do |t|
      t.string :slug
      t.index :slug, unique: true
      t.string :name
      t.text :introduction
      t.text :conclution

      t.timestamps
    end
  end
end
