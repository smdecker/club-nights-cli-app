class ClubNights::CLI

  def call
    puts "Welcome to your weekly listing of club nights"
    list_regions
    select_region
    day
    goodbye
  end

  def list_regions
    puts <<-DOC
      1. London, UK
      2. Berlin, DE
      3. New York, US
      4. Paris, FR
      5. Tokyo, JP
      6. Barcelona, ES
      7. Los Angeles, US
      8. Amsterdam, NL
      9. Manchester, UK
      10. Sydney, AU

      Select your region:
    DOC
  end

  def select_region
    input = gets.strip


    if input.to_i > 0
      puts "Your current location is London, UK."
      puts "Venues: 1762\nUpcoming events: 1278\nTotal population: 8.3M"
    else
      puts "try again"
      restart_list_regions
    end
  end

  def day
    puts "Enter a day (Mon-Sun) you would like to go to the club:"
    input = gets.strip

    if input == "Mon"
      puts "here are your events for Monday:"
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
    list_regions
    select_region
    day
    goodbye
  end

end
