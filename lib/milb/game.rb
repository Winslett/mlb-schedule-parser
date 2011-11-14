module MILB
  class Game
    attr_accessor :schedule, :home_team, :visiting_team, :venue, :starts_at, :id

    private
    def parse(xml)
      @id = (xml.at_xpath("/game") || xml).attributes["pk"].value.to_i

      home_team_xml = xml.at_xpath("//team[@home-team='1']")
      @home_team = @schedule.teams.find { | team | team.id == home_team_xml.attributes["id"].value.to_i } || MILB::Team.new(:xml => home_team_xml, :schedule => @schedule)
      @home_team.games << self if @home_team.games.find { | game | game.id == @id }.nil?

      visiting_team_xml = xml.at_xpath("//team[@home-team='0']")
      @visiting_team = @schedule.teams.find { | team | team.id == visiting_team_xml.attributes["id"].value.to_i } || MILB::Team.new(:xml => visiting_team_xml, :schedule => @schedule)
      @visiting_team.games << self if @visiting_team.games.find { | game | game.id == @id }.nil?

      venue_xml = xml.at_xpath("//venue")
      unless venue_xml.nil?
        @venue = @schedule.venues.find { | venue | venue.name == venue_xml.inner_html } || MILB::Venue.new(:xml => venue_xml, :schedule => @schedule)
        @venue.games << self
      end

      if xml.at_xpath("/game/team[@home-team='1']/local-game-time").inner_html =~ /^([0-9]{4})([0-9]{2})([0-9]{2})([0-9:]+)$/
        @starts_at = Time.parse("#{$1}-#{$2}-#{$3} #{$4}")
      end
    end

    public
    def initialize(args)
      @schedule = args[:schedule]
      parse(Nokogiri::XML(args[:xml].to_s))
    end

    def update(args)
      parse(Nokogiri::XML(args[:xml].to_s))
    end

  end
end
