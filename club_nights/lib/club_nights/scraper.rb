class ClubNights::Scraper

  def self.scrape_region_list
    doc = Nokogiri::HTML(open("https://www.residentadvisor.net/events"))
    doc.xpath('//*[@id="toplist"][2]/ul/li').text.split("/").select! { |x| x.include?(", ") }
  end

  def self.city_country(input)
    location_hash = Hash[*scrape_region_list.map {|region| "#{region.strip.gsub(/[ + ]/, '')},"}.join.split(',')]

    @city = location_hash.map {|k,v| k.downcase }[input.to_i - 1]
    @country = location_hash.map {|k,v| v.downcase }[input.to_i - 1]
  end

  def self.region_stats
    ClubNights::Location.all.clear

    Nokogiri::HTML(open("https://www.residentadvisor.net/guide/#{@country}/#{@city}")).search("ul.stats-list").each do |stats|
      location = ClubNights::Location.new

      location.venues = stats.search("li:nth-child(1) div.large").text
      location.events = stats.search("li:nth-child(2) div.large").text
      location.population = stats.search("li:nth-child(3) div.large").text
    end
  end

  def self.scrape_events(input)
    doc = Nokogiri::HTML(open("https://www.residentadvisor.net/events/#{@country}/#{@city}"))

    event_listing = doc.search('div#event-listing ul#items li p.eventDate a[href]').each_with_object({}) { |atag, hash| hash[atag.text] = atag['href'] }
    event_listing.each do |k,v|
      if input.downcase.include?(k.downcase[/[^,]+/])
        @dayname_href = v
        ClubNights::Location.all.clear
        ClubNights::Location.new.date = k.gsub(" /", '')
      end
    end
  end

  def self.get_events
    doc = Nokogiri::HTML(open("https://www.residentadvisor.net#{@dayname_href}"))
    doc.search("ul#items li div.bbox h1.event-title").map(&:text)
  end

  def self.event_href_title(input)
    doc = Nokogiri::HTML(open("https://www.residentadvisor.net#{@dayname_href}"))

    @event_href = doc.search("#items > li > article > div > h1 > a").map {|link| link.attribute('href').to_s }[input.to_i - 1]
    @event_title = doc.search("#items > li > article > div > h1 > a").map {|event| event.text.to_s }[input.to_i - 1].upcase
  end

  def self.scrape_event_details
    puts "\n\e[4m#{@event_title}\n\e[0m"
    ClubNights::Event.all.clear
    Nokogiri::HTML(open("https://www.residentadvisor.net#{@event_href}")).search("section.contentDetail").each do |details|
      event = ClubNights::Event.new
      event.date = details.xpath('//*[@id="detail"]/ul/li[1]/a','//*[@id="detail"]/ul/li[1]/child::text()').map(&:text).join(" / ")
      event.venue = details.xpath('//*[@id="detail"]/ul/li[2]/a[1]','//*[@id="detail"]/ul/li[2]/child::text()').map(&:text).join(" /")
      event.lineup = details.xpath('//*[@id="event-item"]/div[3]/p[1]').text
      event.description = details.xpath('//*[@id="event-item"]/div[3]/p[2]').text
    end
  end
end
