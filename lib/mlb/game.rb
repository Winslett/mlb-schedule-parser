module MLB
  class Game
    attr_accessor :schedule, :home_team, :visiting_team, :venue, :starts_at, :id

    private
    def parse(xml)
      @id = (xml.at_xpath("/scheduled-game") || xml).attributes["numid"].value.to_i

      home_team_xml = xml.at_xpath("/scheduled-game/team[@isHome='true']")
      @home_team = @schedule.teams.find { | team | team.id == home_team_xml.attributes["strid"].value } || MLB::Team.new(:xml => home_team_xml, :schedule => @schedule)
      @home_team.games << self unless @home_team.games.map(&:id).include?(@id)

      visiting_team_xml = xml.at_xpath("/scheduled-game/team[@isHome='false']")
      @visiting_team = @schedule.teams.find { | team | team.id == visiting_team_xml.attributes["strid"].value } || MLB::Team.new(:xml => visiting_team_xml, :schedule => @schedule)
      @visiting_team.games << self unless @visiting_team.games.map(&:id).include?(@id)

      venue_xml = xml.at_xpath("//venue")
      @venue = @schedule.venues.find { | venue | venue.name == venue_xml.inner_html } || MLB::Venue.new(:xml => venue_xml, :schedule => @schedule)
      @venue.games << self unless @venue.games.map(&:id).include?(@id)

      @starts_at = case
                   when (xml/"//time").length == 0
                     Time.parse((xml/"//date").first.inner_html)
                   else
                     Time.parse((xml/"//date").first.inner_html + " " + (xml/"//time").first.inner_html)
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
