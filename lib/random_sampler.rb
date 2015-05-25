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
  end
end
