module MILB
  class Schedule
    attr_accessor :games, :venues, :teams

    private
    def parse(xml_schedule)
      xml_schedule = Nokogiri::XML(xml_schedule)

      (xml_schedule/'//game').each do | xml_game |
        game = @games.find { | game | game.id == xml_game.attributes["pk"].value.to_i }

        if game.nil?
          @games << MILB::Game.new(:xml => xml_game, :schedule => self)
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
