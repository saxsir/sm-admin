class AddMathingResultColumnsToWebPages < ActiveRecord::Migration
  def change
    add_column :web_pages, :matching_result, :integer
  end
end
