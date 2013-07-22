class DropChoicesTable < ActiveRecord::Migration
  def up
    drop_table :choices
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
