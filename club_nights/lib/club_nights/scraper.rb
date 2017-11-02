class ClubNights::Scraper

  def self.scrape_list
    doc = Nokogiri::HTML(open("https://www.residentadvisor.net/events"))

    doc.search("section#toplist:nth-child(2) ul li").text.split("/").select! { |x| x.include?(", ") }
  end

  def self.make_region_list
    scrape_list.each.with_index(1) do |region, i|
      puts "#{i}. #{region}"
    end
  end

end
