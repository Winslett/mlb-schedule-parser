require 'nokogiri'
require 'time'

module MILB

  autoload :Schedule, File.dirname(__FILE__) + '/milb/schedule.rb'
  autoload :Game,     File.dirname(__FILE__) + '/milb/game.rb'
  autoload :Venue,    File.dirname(__FILE__) + '/milb/venue.rb'
  autoload :Team,     File.dirname(__FILE__) + '/milb/team.rb'

end
