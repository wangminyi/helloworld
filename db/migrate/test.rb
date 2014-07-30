class addColumn < ActiveRecord::Migration
  def change
    add_column :bookmarks, :type, :integer, default:false
  end
end
