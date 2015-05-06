class AddIndexToWebpagesUrl < ActiveRecord::Migration
  def change
      add_index :web_pages, :url, unique: true
  end
end
