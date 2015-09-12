class AddColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :users, :type, :integer
    add_column :users, :gender,:integer
  end
end
