module MLB
  class Game
    attr_accessor :schedule, :home_team, :visiting_team, :venue, :starts_at, :id

    private
    def parse(xml)
      @id = xml.xpath("//scheduled-game").first.attribute("numid").to_s.to_i

      home_team_xml = xml.xpath("//team[@ishome='true']").first
      @home_team = @schedule.teams.find { | team | team.id == home_team_xml.attribute("strid") } || MLB::Team.new(:xml => home_team_xml, :schedule => @schedule)

      visiting_team_xml = xml.xpath("//team[@ishome='false']").first
      @visiting_team = @schedule.teams.find { | team | team.id == visiting_team_xml.attribute("strid") } || MLB::Team.new(:xml => visiting_team_xml, :schedule => @schedule)

      venue_xml = xml.xpath("//venue").first
      @venue = @schedule.venues.find { | venue | venue.name == venue_xml.content } || MLB::Venue.new(:xml => venue_xml, :schedule => @schedule)
      @venue.games << self

      @starts_at = Time.parse(xml.xpath("//date").first.content + " " + xml.xpath("//time").first.content)
    end

    public
    def initialize(args)
      @schedule = args[:schedule]
      parse(Nokogiri::HTML(args[:xml].to_s))
    end

  end
end
