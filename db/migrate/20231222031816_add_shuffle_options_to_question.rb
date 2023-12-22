class AddShuffleOptionsToQuestion < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :shuffle_options, :boolean, default: false
  end
end
