# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

[
    'http://www.24-7.co.jp/',
    'http://www.turbine.co.jp/profile/outline',
    'http://www.e-bird.biz/recruit/',
    'http://www.advance.ws/contents/web/web.html',
    'http://unique-experience.xyz/?p=808',
    'http://www.locus-inc.co.jp/service/web/index.html',
    'http://www.kcscorp.jp/?page_id=2737',
    'http://www.wareserve.co.jp/Solution/frmHP.aspx',
    'http://www.globalife.co.jp/smart/business-p.php',
    'http://www.morihara.jp/%E3%82%B5%E3%83%BC%E3%83%93%E3%82%B9%E7%B4%B9%E4%BB%8B/web%E5%88%B6%E4%BD%9C/',
    'http://www.lty.co.jp/modules/tinyd1/index.php?id=3',
    'http://www.vintage.ne.jp/blog/?itemid=195',
    'http://www.youtube.com/watch?v=SDD77prg4Aw'
].each do |url|
    web_page = WebPage.new(:url => url)
    begin
        web_page.save
    rescue => err
        p err.message
    ensure
        puts url
    end
end
