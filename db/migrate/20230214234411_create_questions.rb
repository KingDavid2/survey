class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions, id: :uuid do |t|
      t.references :survey, null: false, foreign_key: true, type: :uuid
      t.string :type
      t.string :question_text
      t.string :default_text
      t.string :placeholder
      t.string :position
      t.string :answer_options
      t.string :validation_rules

      t.timestamps
    end
  end
end
