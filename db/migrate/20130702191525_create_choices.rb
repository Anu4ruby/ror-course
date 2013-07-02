class CreateChoices < ActiveRecord::Migration
  def change
    create_table :choices do |t|
      t.text :description
      t.references :question

      t.timestamps
    end
    add_index :choices, :question_id
  end
end
