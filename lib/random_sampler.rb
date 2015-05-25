require 'json'
class RandomSampler
  # wikipediaからランダムな単語を取得する
  def self.get_random_keyword
    # htmlの<title>タグで囲まれた文字列を抽出
    `curl -sL http://ja.wikipedia.org/wiki/Special:Randompage`.match(/<title>([^<]+)<\/title>/)

    title = $1.split(' - ').first
    return title
  end

  # 受け取ったクエリでgoogle検索し、上位10件のURLを取得する
  def self.fetch_urls(query)
    json = `node lib/fetchUrls.js '#{query}'`

    begin
      urls = JSON.parse(json)
    rescue => err
      puts "[Search Error] Could not parse return value json"
      urls = []
    end

    return urls
  end

  # Webページをランダムサンプリングする
  def self.random_sampling
    # 100データ超えるまでループ
    while (WebPage.all.size < 100) do
      query = self.get_random_keyword
      urls = self.fetch_urls(query)

      # 新しいWebPageモデルを保存
      urls.each do |url|
        web_page = WebPage.new(:url => url, :query => query)
        begin
          web_page.save
        rescue => err
          p err.message
        ensure
          puts url
        end
      end
    end
  end
end
