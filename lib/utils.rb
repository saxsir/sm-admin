require 'csv'

class Utils
  def self.read_csv(fp)
    filepath = File.expand_path(fp, __FILE__)
    return CSV.read(filepath)
  end

  def self.insert_urls
    *rows = self.read_csv('../../tmp/companies.csv')

    rows.each { |url|
      web_page = WebPage.new(:url => url[0])
      begin
        web_page.save
      rescue => err
        p err.message
      ensure
        puts url[0]
      end
    }
  end
end
