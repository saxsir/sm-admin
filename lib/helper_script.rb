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
      # TODO: curlで200返ってきたらキャプチャする
      # status = curl hoge hoge

      res_json = `node_modules/phantomjs/bin/phantomjs bin/sample.js "#{page.url}"`.chomp
      res = JSON.parse(res_json)

      status = res['status']
      puts "#{i}: #{status}, page_id=#{page.id}"

      if status == 'success'
        # TODO: 画像の保存場所はgyazoにアップしたタイミングで更新する
        page.captured_at = Time.zone.now
        begin
          page.save
        rescue => err
          p err.message
        end
      end
    end
  end
end
