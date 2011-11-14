module MLB
  class Team
    attr_accessor :schedule, :id, :name, :games

  private
    def parse(team_xml)
      @name = team_xml.inner_html
      @id   = team_xml.attributes["strid"].value
      @schedule.teams << self
    end

  public
    def initialize(args)
      @schedule, @games = args[:schedule], []
      parse(args[:xml])
    end

  end
end
