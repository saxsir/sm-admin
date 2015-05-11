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

      # curlで200レスポンス以外だったらキャプチャ処理しない
      http_code = `curl -LI "#{page.url}" -o /dev/null -w '%{http_code}\n' -s`.chomp
      if http_code != '200'
        puts "#{i}: [HTTP Error] #{http_code}, #{page.url}, page_id=#{page_id}"
        next
      end

      # 画面キャプチャ処理、返り値はレイアウト情報
      res_json = `node_modules/phantomjs/bin/phantomjs bin/sample.js "#{page.url}"`.chomp
      res = JSON.parse(res_json)

      # PhantomJSが何らかの理由でこけてたら処理終了
      status = res['status']
      if status != 'success'
        puts "#{i}: [PhantomJS Error] #{status}, #{page.url}, page_id=#{page.id}"
        next
      end

      # TODO: 画像の保存場所はgyazoにアップしたタイミングで更新する
      # DBの更新処理
      page.captured_at = Time.zone.now
      begin
        page.save
      rescue => err
        p err.message
      end

      puts "#{i}: [Success] #{page.url}, page_id=#{page.id}"
    end
  end
end
