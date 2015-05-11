class AddSeparetedImagePathToWebpages < ActiveRecord::Migration
  def change
    add_column :web_pages, :separated_image_path, :string
  end
end
