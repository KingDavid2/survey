class AddConclusion2OnNotAcceptanceToSurvey < ActiveRecord::Migration[7.0]
  def change
    add_column :surveys, :conclusion_2_on_not_acceptance, :boolean, default: false
  end
end
