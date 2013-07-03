class ChangeTypeToQtypeInQuestion < ActiveRecord::Migration
  def change
    rename_column :questions, :type, :qtype
  end
end
