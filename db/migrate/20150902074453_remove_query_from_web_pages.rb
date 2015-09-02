class RemoveQueryFromWebPages < ActiveRecord::Migration
  def change
    remove_column :web_pages, :query, :string
  end
end
