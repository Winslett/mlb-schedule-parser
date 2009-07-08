module MLB
  class Team
    attr_accessor :schedule, :id, :name

  private
    def parse(team_xml)
      @name = team_xml.content
      @id   = team_xml.attribute("strid")
      @schedule.teams << self 
    end

  public
    def initialize(args)
      @schedule = args[:schedule]
      parse(args[:xml])
    end

  end
end
