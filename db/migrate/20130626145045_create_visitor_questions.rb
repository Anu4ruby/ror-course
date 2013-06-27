class CreateVisitorQuestions < ActiveRecord::Migration
  def change
    create_table :visitor_questions do |t|
      t.string :email
      t.text :description
      t.text :respond

      t.timestamps
    end
  end
end
