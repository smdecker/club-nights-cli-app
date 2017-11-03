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
    input = gets.strip

    if input == "Mon"
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
    input = nil
    puts "These are your events for Mon, 06 Nov 2017:"
    puts "
    1. Flying Lotus in 3Dat Brooklyn Steel
    2. The One Where Allen Plays at Bossa Nova Civic Club
    3. Industry Night with Elon David Paglia at TBA Brooklyn
    4. Shhh Monday Morning Membership After Hours Music By: Darelectric at TBA - New York\r\n"

    puts "Select an event to get more info or enter 'back' for a different day. You can also type 'region' for a different location or 'exit'"

    while input != "exit"
        input = gets.strip
      if input == "back"
        restart_day
      elsif input.to_i > 0
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
  end

  def event_details
    puts "
    ===Industry Night with Elon David Paglia===
    / Date:
    Monday / 6 Nov 2017 / 21:00 - 04:00

    / Venue:
    TBA Brooklyn
    395 Wythe Ave; Brooklyn, NY 11249; USA

    / Cost
    Free

    / Line-up
    Elon
    David Paglia

    / Description
    A banana (Elon) and a Paisano (David Paglia) come together, lugging in their respective vinyl collections to deliver an aural delicacy of rhythms and grooves spanning multiple genres of music including house, disco, funk, techno, downtempo, midtempo, uptempo, all tempos and everything in between...a back to back musical concoction for getting down & bar side chill with cocktails and conversation. Banana e Paisano occurs the first Monday of the month...

    Industry Night at TBA
    w/ Monthly Residents:

    Elon + David Paglia
    https://soundcloud.com/elon
    https://soundcloud.com/davidpaglia

    Drink Specials:
    $5 Yuengling pints
    $8 Moscow Mules
    All NIGHT

    Free
    21+
    "
    puts "\r\n'back' to see the event list again\r\n'day' to select another day\r\n'region' to select a different location\r\nor 'exit'"

    input = nil
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
