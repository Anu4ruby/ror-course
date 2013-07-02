class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.text :description
      t.string :posted_by
      t.references :question
      t.references :choice

      t.timestamps
    end
    add_index :answers, :question_id
    add_index :answers, :choice_id
  end
end
