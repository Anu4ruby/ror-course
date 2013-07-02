class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :description
      t.string :type
      t.string :created_by

      t.timestamps
    end
  end
end
