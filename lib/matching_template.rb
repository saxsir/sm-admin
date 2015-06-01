require 'json'

class MatchingTemplate
  # curlで200が返ってくるか確認する関数
  def self.response?(url)
      http_code = `curl -LI "#{url}" -o /dev/null -w '%{http_code}\n' -s`.chomp
      puts "[curl] #{http_code}"    # debug

      if http_code != '200'
        puts "[HTTP Error] #{http_code}, #{url}"
        return false
      end

      return true
  end

  # まだキャプチャしていないページを対象にキャプチャし続ける
  def self.run
    WebPage.where(matching_result: [nil]).each.with_index(1) do |page, i|

      puts "=== [#{i}] #{page.url} ==="    # debug
      puts "page_id: #{page.id}"    # debug

      # curlで200レスポンス以外だったらキャプチャ処理しない
      unless self.response?(page.url) then next end

      # 画面キャプチャ処理、返り値はレイアウト情報
      res_json = `node_modules/phantomjs/bin/phantomjs bin/matchingTemplete.js "#{page.url}"`.chomp
      begin
        res = JSON.parse(res_json)
      rescue => err
        puts "[PhantomJS Error] Could not parse return value json"
        next
      end

      status = res['status']
      puts "[phantomjs] #{status}"    # debug

      # PhantomJSが何らかの理由でこけてたら処理終了
      if status != 'success'
        puts "[PhantomJS Error] #{status}, #{page.url}, page_id=#{page.id}"
        next
      end

      puts "[Template] T#{res['templateId']}"

      # DBの更新処理
      # TODO: サムネイルも保存するようにする（DBにカラム追加）
      page.matching_result = res['templateId']
      begin
        page.save
        puts "[sqlite] saved"
      rescue => err
        puts "[sqlite error] Could not save page object"
      end
    end
  end
end
