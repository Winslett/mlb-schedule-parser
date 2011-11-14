require 'nokogiri'
require 'time'

module MLB

  autoload :Schedule, File.dirname(__FILE__) + '/mlb/schedule.rb'
  autoload :Game,     File.dirname(__FILE__) + '/mlb/game.rb'
  autoload :Venue,    File.dirname(__FILE__) + '/mlb/venue.rb'
  autoload :Team,     File.dirname(__FILE__) + '/mlb/team.rb'

end
