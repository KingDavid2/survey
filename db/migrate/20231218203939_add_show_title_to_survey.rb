class AddShowTitleToSurvey < ActiveRecord::Migration[7.0]
  def change
    add_column :surveys, :show_title, :boolean, default: true
  end
end
