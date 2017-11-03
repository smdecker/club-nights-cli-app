class ClubNights::Location
  attr_accessor :venues, :events, :population

  @@all = []

  def initialize
    @@all << self
  end

  def self.all
    @@all
  end

end