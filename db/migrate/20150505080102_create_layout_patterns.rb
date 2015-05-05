class CreateLayoutPatterns < ActiveRecord::Migration
  def change
    create_table :layout_patterns do |t|
      t.string :name, :null => false
      t.text :note

      t.timestamps null: false
    end
  end
end
