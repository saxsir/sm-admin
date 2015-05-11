class AddLayoutDataColumnToWebpages < ActiveRecord::Migration
  def change
    add_column :web_pages, :layout_data, :text
  end
end
