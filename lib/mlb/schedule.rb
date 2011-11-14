module MLB
  class Schedule
    attr_accessor :games, :venues, :teams

    private
    def parse(xml_schedule)
      xml_schedule = Nokogiri::XML(xml_schedule)

      xml_schedule.xpath('//scheduled-game').each do | xml_game |
        game = @games.find { | game | game.id == xml_game.attributes["numid"].value.to_i }

        if game.nil?
          @games << MLB::Game.new(:xml => xml_game, :schedule => self)
        else
          game.update(:xml => xml_game)
        end
      end
    end

    public
    def initialize(xml)
      @games, @venues, @teams = [], [], []
      parse(xml)
    end

    def add(xml)
      parse(xml)
    end

  end
end
