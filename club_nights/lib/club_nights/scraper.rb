class ClubNights::Scraper

  def self.scrape_region_list
    doc = Nokogiri::HTML(open("https://www.residentadvisor.net/events"))

    doc.xpath('//*[@id="toplist"][2]/ul/li').text.split("/").select! { |x| x.include?(", ") }
  end

  def self.make_region_list
    scrape_region_list.each.with_index(1) do |region, i|
      puts "#{i}. #{region}"
    end
  end

  def self.scrape_city_country(input)
    strip_location = Hash[*scrape_region_list.collect(&:strip).map {|word| "#{word},"}.join.gsub(/[ + ]/, '').split(',')]

    @city = strip_location.map {|k,v| k.downcase }[input.to_i - 1]
    @country = strip_location.map {|k,v| v.downcase }[input.to_i - 1]
  end

end