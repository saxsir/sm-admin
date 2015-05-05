class CreateWebPages < ActiveRecord::Migration
  def change
    create_table :web_pages do |t|
      t.string :url
      t.string :capture_image_path
      t.integer :layout_pattern_id
      t.text :note

      t.timestamps null: false
    end
  end
end
