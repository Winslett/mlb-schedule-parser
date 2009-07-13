module MLB
  class Venue
    attr_accessor :name, :schedule, :games

    private
    def parse(venue_xml)
      @name = venue_xml.inner_html
      @schedule.venues << self
    end

    public
    def initialize(args)
      @schedule, @games = args[:schedule], []
      parse(args[:xml])
    end

  end
end
