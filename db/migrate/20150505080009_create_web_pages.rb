class CreateWebPages < ActiveRecord::Migration
  def change
    create_table :web_pages do |t|
      t.string :url, :null => false
      t.string :query, :null => false
      t.string :capture_image_path, :null => false
      t.integer :layout_pattern_id, :null => false
      t.text :note

      t.timestamps null: false
    end
  end
end
