module MLB
  class Game
    attr_accessor :schedule, :home_team, :visiting_team, :venue, :starts_at, :id

    private
    def parse(xml)
      @id = xml.xpath("//scheduled-game").first.attribute("numid").to_s.to_i

      home_team_xml = xml.xpath("//team[@ishome='true']").first
      @home_team = @schedule.teams.find { | team | team.id == home_team_xml.attribute("strid").to_s } || MLB::Team.new(:xml => home_team_xml, :schedule => @schedule)
      @home_team.games << self if @home_team.games.find { | game | game.id == @id }.nil?

      visiting_team_xml = xml.xpath("//team[@ishome='false']").first
      @visiting_team = @schedule.teams.find { | team | team.id == visiting_team_xml.attribute("strid").to_s } || MLB::Team.new(:xml => visiting_team_xml, :schedule => @schedule)
      @visiting_team.games << self if @visiting_team.games.find { | game | game.id == @id }.nil?

      venue_xml = xml.xpath("//venue").first
      @venue = @schedule.venues.find { | venue | venue.name == venue_xml.content } || MLB::Venue.new(:xml => venue_xml, :schedule => @schedule)
      @venue.games << self

      @starts_at = case
                   when xml.xpath("//time").length == 0
                     Time.parse(xml.xpath("//date").first.content)
                   else 
                     Time.parse(xml.xpath("//date").first.content + " " + xml.xpath("//time").first.content)
                   end
    end

    public
    def initialize(args)
      @schedule = args[:schedule]
      parse(Nokogiri::HTML(args[:xml].to_s))
    end

    def update(args)
      parse(args[:xml])
    end

  end
end
