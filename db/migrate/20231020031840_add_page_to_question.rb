class AddPageToQuestion < ActiveRecord::Migration[7.0]
  def up
    add_column :questions, :page, :integer

    execute <<~SQL
      UPDATE questions
      SET page = section
    SQL
  end

  def down
    remove_column :questions, :page, :integer
  end
end
