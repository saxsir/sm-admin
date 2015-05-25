class RandomSampler
  # wikipediaからランダムな単語を取得する
  def self.get_random_keyword
    puts `curl http://ja.wikipedia.org/wiki/Special:Randompage -sL G \<title\>`
  end

  # 受け取ったクエリでgoogle検索し、上位10件のURLを取得する
  def self.fetch_urls(query)
  end
end
