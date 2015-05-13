require 'json'

class HelperScript
  def self.insert_multiple_urls
    file_path = ARGV[0]

    #TODO: ファイル名（引数）がなかったらコマンドの使用例を表示する
    File.open(file_path) do |f|
      f.each_line do |line|
        web_page = WebPage.new(:url => line.chomp)

        begin
          web_page.save
        rescue => err
          puts err.message
        ensure
          puts line
        end
      end
    end
  end

  def self.capture_images
    WebPage.where(captured_at: [nil])
    .each.with_index(1) do |page, i|

      puts "=== [#{i}] #{page.url} ==="    # debug
      puts "page_id: #{page.id}"    # debug

      # curlで200レスポンス以外だったらキャプチャ処理しない
      http_code = `curl -LI "#{page.url}" -o /dev/null -w '%{http_code}\n' -s`.chomp
      if http_code != '200'
        puts "#{i}: [HTTP Error] #{http_code}, #{page.url}, page_id=#{page.id}"
        next
      end
      puts "[curl] #{http_code}"    # debug

      # 画面キャプチャ処理、返り値はレイアウト情報
      res_json = `node_modules/phantomjs/bin/phantomjs bin/getData.js "#{page.url}"`.chomp
      begin
        res = JSON.parse(res_json)
      rescue => err
        puts "[PhantomJS Error] Could not parse return value json"
        # p err.message
        next
      end

      # PhantomJSが何らかの理由でこけてたら処理終了
      status = res['status']
      if status != 'success'
        puts "#{i}: [PhantomJS Error] #{status}, #{page.url}, page_id=#{page.id}"
        next
      end
      puts "[phantomjs] #{status}"    # debug

      # gyazoにキャプチャ画像をアップロード
      gyazo_res_json_original = `curl -s https://upload.gyazo.com/api/upload\?access_token\=#{Rails.application.secrets.gyazo_access_token} -F "imagedata=@#{res['original_image_file_path']}"`.chomp
      begin
        gyazo_res_original = JSON.parse(gyazo_res_json_original)
      rescue => err
        puts "[gyazo error] Could not upload original image"
        # p err.message
        next
      end

      gyazo_res_json_separated = `curl -s https://upload.gyazo.com/api/upload\?access_token\=#{Rails.application.secrets.gyazo_access_token} -F "imagedata=@#{res['separated_image_file_path']}"`.chomp
      begin
        gyazo_res_separated = JSON.parse(gyazo_res_json_separated)
      rescue => err
        puts "[gyazo error] Could not upload separated image"
        # p err.message
        next
      end

      # TODO: gyazoからエラーが返ってきた場合の処理を追加

      # DBの更新処理
      # TODO: サムネイルも保存するようにする（DBにカラム追加）
      page.capture_image_path = gyazo_res_original['url']
      page.separated_image_path = gyazo_res_separated['url']
      page.captured_at = Time.zone.now
      page.layout_data = res['layout_data']
      begin
        page.save
        puts "[sqlite] saved"
      rescue => err
        puts "[sqlite error] Could not save page object"
        # p err.message
      end
    end
  end
end
