class AddCapturedAtToWebpages < ActiveRecord::Migration
  def change
    add_column :web_pages, :captured_at, :timestamps
  end
end
