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

  def self.region_stats
    Nokogiri::HTML(open("https://www.residentadvisor.net/guide/#{@country}/#{@city}")).search("ul.stats-list").each do |stats|
      location = ClubNights::Location.new

      location.venues = stats.search("li:nth-child(1) div.large").text
      location.events = stats.search("li:nth-child(2) div.large").text
      location.population = stats.search("li:nth-child(3) div.large").text
    end
  end

  def self.scrape_events(input)
    doc = Nokogiri::HTML(open("https://www.residentadvisor.net/events/#{@country}/#{@city}"))
    event_listing = doc.search('div#event-listing ul#items li p.eventDate a[href]').each_with_object({}) { |atag, hash| hash[atag.text.strip] = atag['href'] }
    event_listing.select do |k,v|
      if input.downcase.include?(k.downcase[/[^,]+/])
        @event_url = v
      end
    end
  end

  def self.get_events
    doc = Nokogiri::HTML(open("https://www.residentadvisor.net#{@event_url}"))
    # binding.pry
    doc.search("ul#items li div.bbox h1.event-title").map(&:text).each.with_index(1) { |event, i| puts "#{i}. #{event}"}
  end
end
