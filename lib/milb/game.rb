module MILB
  class Game
    attr_accessor :schedule, :home_team, :visiting_team, :venue, :starts_at, :id

    private
    def parse(xml)
      @id = ((xml/"//game").first || (xml)  ).attributes["pk"].to_i

      home_team_xml = (xml/"//team[@home-team='1']").first
      @home_team = @schedule.teams.find { | team | team.id == home_team_xml.attributes["id"].to_i } || MILB::Team.new(:xml => home_team_xml, :schedule => @schedule)
      @home_team.games << self if @home_team.games.find { | game | game.id == @id }.nil?

      visiting_team_xml = (xml/"//team[@home-team='0']").first
      @visiting_team = @schedule.teams.find { | team | team.id == visiting_team_xml.attributes["id"].to_i } || MILB::Team.new(:xml => visiting_team_xml, :schedule => @schedule)
      @visiting_team.games << self if @visiting_team.games.find { | game | game.id == @id }.nil?

      venue_xml = (xml/"//venue").first
      unless venue_xml.nil?
        @venue = @schedule.venues.find { | venue | venue.name == venue_xml.inner_html } || MILB::Venue.new(:xml => venue_xml, :schedule => @schedule)
        @venue.games << self
      end

      @starts_at = case
                   when (xml/"//time").length == 0
                     Time.parse((xml/"//date").inner_html)
                   else 
                     Time.parse((xml/"//date").inner_html + " " + (xml/"//time").inner_html)
                   end
    end

    public
    def initialize(args)
      @schedule = args[:schedule]
      parse(Hpricot(args[:xml].to_s))
    end

    def update(args)
      parse(args[:xml])
    end

  end
end
