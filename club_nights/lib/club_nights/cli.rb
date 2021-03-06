class ClubNights::CLI

  def call
    puts "\n •-•-•-•-•-•-•-•-•-•-•-•-•-•-•-•-•-•-•-•-•-•-•-•-•"
    puts "               Welcome to Club Nights             "
    puts "                       • • •                      "
    puts "  your weekly listings of electronic music events "
    puts " •-•-•-•-•-•-•-•-•-•-•-•-•-•-•-•-•-•-•-•-•-•-•-•-•\n\n"
    list_region
    select_region
    day
    event_list
    event_details
    goodbye
  end

  def list_region
    ClubNights::Scraper.scrape_region_list.first(15).each.with_index(1) {|region, i| puts "#{i}. #{region}"}
    puts "\nSelect your region:"
  end

  def select_region
    input = gets.strip

    if input.to_i <= 15
      ClubNights::Scraper.city_country(input)
      ClubNights::Scraper.region_stats

      region = ClubNights::Scraper.scrape_region_list[input.to_i - 1]
        puts "\nYour current location is #{region}\b."

      ClubNights::Location.all.each do |stats|
        puts "Venues: #{stats.venues}\nUpcoming events: #{stats.events}\nTotal population: #{stats.population}"
      end

    else
      puts "\nPlease enter a valid command."
      restart_list_region
    end
  end

  def day
    puts "\n-------------------------------------------------------"
    puts "Enter a day (Mon-Sun) you would like to go to the club:\n\n'region' for a different location\n'exit' to quit"

    input = gets.strip.downcase
    day_names = Date::DAYNAMES.join.downcase

    if day_names.include?(input)
      ClubNights::Scraper.scrape_events(input)
    elsif input == "region"
      restart_list_region
    elsif input == "exit"
      goodbye
    else
      puts "\nPlease enter a valid command."
      day
    end
  end

  def event_list
    ClubNights::Location.all.each {|event_date| puts "\n\e[4mYour events for #{event_date.date}:\n\e[0m"}

    events = ClubNights::Scraper.get_events.each.with_index(1) { |event, i| puts "#{i}. #{event}"}

    puts "\n---------------------------------"
    puts "Select an event to get more info:\n\n'day' for a different day\n'region' for a different location\n'exit' to quit"
    input = gets.strip

    if input.to_i.between?(1, events.size)
      ClubNights::Scraper.event_href_title(input)
    elsif input == "day"
      restart_day
    elsif input == "region"
      restart_list_region
    elsif input == "exit"
      goodbye
    else
      puts "\nPlease enter a valid command."
      restart_event_list
    end
  end

  def event_details
    ClubNights::Scraper.scrape_event_details
    ClubNights::Event.all.each do |details|
      puts "/ DATE:\n#{details.date}\n\n/ VENUE:\n#{details.venue}\n\n/ LINE UP:\n#{details.lineup}\n\n/ DESCRIPTION:#{details.description}"
    end

    puts "\n'events' to see the event list again\n'day' for a different day\n'region' for a different location\n'exit' to quit"

    input = gets.strip
    if input == "events"
      restart_event_list
    elsif input == "day"
      restart_day
    elsif input == "region"
      restart_list_region
    elsif input == "exit"
      goodbye
    else
      puts "\nPlease enter a valid command."
      event_details
    end
  end

  def goodbye
    puts "\nSee you at the club!\n\n"
    exit
  end

  def restart_list_region
    list_region
    select_region
    day
    event_list
    event_details
    goodbye
  end

  def restart_event_list
    event_list
    event_details
    goodbye
  end

  def restart_day
    day
    event_list
    event_details
    goodbye
  end
end
