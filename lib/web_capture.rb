require 'json'

class WebCapture
  # curlで200が返ってくるか確認する関数
  def self.response?(url)
      http_code = `curl -LI "#{url}" -o /dev/null -w '%{http_code}\n' -s`.chomp
      puts "[curl] #{http_code}"    # debug

      if http_code != '200'
        puts "#{i}: [HTTP Error] #{http_code}, #{url}"
        return false
      end

      return true
  end

  # まだキャプチャしていないページを対象にキャプチャし続ける
  def self.capture
    WebPage.where(captured_at: [nil]).each.with_index(1) do |page, i|

      puts "=== [#{i}] #{page.url} ==="    # debug
      puts "page_id: #{page.id}"    # debug

      # curlで200レスポンス以外だったらキャプチャ処理しない
      unless self.response?(page.url) then next end

      # 画面キャプチャ処理、返り値はレイアウト情報
      res_json = `node_modules/phantomjs/bin/phantomjs bin/getData.js "#{page.url}"`.chomp
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
        puts "#{i}: [PhantomJS Error] #{status}, #{page.url}, page_id=#{page.id}"
        next
      end

      # DBの更新処理
      # TODO: サムネイルも保存するようにする（DBにカラム追加）
      page.capture_image_path = res['original_image_file_path'].gsub("/home/sasamoto/workspace/admin.smart-markup/public", "")
      page.separated_image_path = res['separated_image_file_path'].gsub("/home/sasamoto/workspace/admin.smart-markup/public", "")
      page.captured_at = Time.zone.now
      page.layout_data = res['layout_data']
      begin
        page.save
        puts "[sqlite] saved"
      rescue => err
        puts "[sqlite error] Could not save page object"
      end
    end
  end
end
