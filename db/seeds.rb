# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# レイアウトテンプレートを登録
['T1', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'T8'].each do |template|
  layout_pattern = LayoutPattern.new(:name => template)
  begin
    layout_pattern.save
  rescue => err
    p err.message
  ensure
    puts template
  end
end
