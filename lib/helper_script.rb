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
end
