class CreateLayoutPatterns < ActiveRecord::Migration
  def change
    create_table :layout_patterns do |t|
      t.string :name
      t.text :note

      t.timestamps null: false
    end
  end
end
