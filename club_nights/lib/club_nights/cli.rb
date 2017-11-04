class ClubNights::CLI

  def call
    puts "Welcome to your weekly listing of club nights\n\n"
    list_region
    select_region
    day
    event_list
    event_details
    goodbye
  end

  def list_region
    ClubNights::Scraper.make_region_list
    puts "\nSelect your region:"
  end

  def select_region
    input = gets.strip
    if input.to_i > 0
      ClubNights::Scraper.scrape_city_country(input)
      ClubNights::Scraper.region_stats

      region = ClubNights::Scraper.scrape_region_list[input.to_i - 1]
        puts "Your current location is #{region}\b."

      ClubNights::Location.all.each do |stats|
        puts "Venues: #{stats.venues}\nUpcoming events: #{stats.events}\nTotal population: #{stats.population}"
        puts ""
      end
      ClubNights::Location.all.clear
    else
      puts "try again"
      restart_list_region
    end
  end

  def day
    puts "Enter a day (Mon-Sun) you would like to go to the club:"
    puts "'back' to select different location"
    puts "'exit' to quit"

    input = gets.strip.downcase
    day_names = Date::DAYNAMES.join.downcase

    if day_names.include?(input)
      ClubNights::Scraper.scrape_events(input)
      event_list
    elsif input == "back"
      restart_list_region
    elsif input == "exit"
      goodbye
      exit
    else
      puts "try again"
      day
    end
  end

  def event_list
    ClubNights::Scraper.get_events
    # puts "These are your events for Mon, 06 Nov 2017:"
    # puts "
    # 1. Flying Lotus in 3Dat Brooklyn Steel
    # 2. The One Where Allen Plays at Bossa Nova Civic Club
    # 3. Industry Night with Elon David Paglia at TBA Brooklyn
    # 4. Shhh Monday Morning Membership After Hours Music By: Darelectric at TBA - New York\r\n"
    #
    puts "Select an event to get more info or enter 'back' for a different day. You can also type 'region' for a different location or 'exit'"
    input = gets.strip
    if input == "back"
      restart_day
    elsif input.to_i > 0
      ClubNights::Scraper.return_event(input)
      event_details
    elsif input == "region"
      restart_list_region
    elsif input == "exit"
      goodbye
      exit
    else
      puts "try again"
      restart_event_list
    end
  end

  def event_details
    ClubNights::Scraper.single_event
    ClubNights::Event.all.each do |details|
      puts "/ DATE:\n#{details.date}\n\n/ VENUE:\n#{details.venue}\n\n/ LINE UP:\n#{details.lineup}\n\n/ DESCRIPTION:#{details.description}"
    end

    puts "\r\n'back' to see the event list again\r\n'day' to select another day\r\n'region' to select a different location\r\nor 'exit'"
    ClubNights::Event.all.clear

    input = gets.strip
    if input == "back"
      restart_event_list
    elsif input == "day"
      restart_day
    elsif input == "region"
      restart_list_region
    elsif input == "exit"
      goodbye
      exit
    else
      puts "try again"
    end
  end


  def goodbye
    puts "see you at the club!"
  end

###

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
