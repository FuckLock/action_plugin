class CreateActions < ActiveRecord::Migration[5.0]
  def change
    create_table :actions do |t|
      t.integer :subject_id
      t.string :subject_type
      t.string :action_type
      t.string :target_type
      t.integer :target_id

      t.timestamps
    end

    add_index :actions, %w[subject_id subject_type action_type target_type]
    add_index :actions, %w[target_id target_type action_type subject_type]
  end
end
