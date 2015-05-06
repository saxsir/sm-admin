class ChangeColumnToWebPage < ActiveRecord::Migration
    def up
        change_column :web_pages, :capture_image_path, :string, null: true
        change_column :web_pages, :layout_pattern_id, :integer, null: true
    end

    def down
        change_column :web_pages, :capture_image_path, :string, null: false
        change_column :web_pages, :layout_pattern_id, :integer, null: false
    end
end
