module MILB
  class Team
    attr_accessor :schedule, :id, :name, :games

  private
    def parse(team_xml)
      @name = (team_xml/"//city").first.inner_html + " " + (team_xml/"//name").first.inner_html
      @id   = team_xml.attributes["id"].value.to_i
      @schedule.teams << self
    end

  public
    def initialize(args)
      @schedule, @games = args[:schedule], []
      parse(args[:xml])
    end

  end
end
