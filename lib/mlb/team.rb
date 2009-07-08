module MLB
  class Team
    attr_accessor :schedule, :id, :name, :games

  private
    def parse(team_xml)
      @name = team_xml.content.to_s
      @id   = team_xml.attribute("strid").to_s
      @schedule.teams << self 
    end

  public
    def initialize(args)
      @schedule, @games = args[:schedule], []
      parse(args[:xml])
    end

  end
end
