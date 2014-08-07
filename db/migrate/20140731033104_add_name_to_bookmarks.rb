class AddNameToBookmarks < ActiveRecord::Migration
  def change
    add_column :Bookmarks, :name, :string
  end
end
