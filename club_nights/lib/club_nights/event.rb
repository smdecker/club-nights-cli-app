class ClubNights::Event
  attr_accessor :date, :venue, :lineup, :description
  
  @@all = []

  def initialize
    @@all << self
  end

  def self.all
    @@all
  end

end