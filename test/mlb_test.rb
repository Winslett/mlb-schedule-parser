require 'rubygems'
require 'test/unit'
require File.dirname(__FILE__) + '/../lib/mlb'

require 'shoulda'

class MLB_Test < Test::Unit::TestCase

  context "An MLB schedule" do
    setup do
      @schedule = MLB::Schedule.new(File.read('test/fixtures/2009-07-09.xml'))
    end

    should "have many games" do
      assert @schedule.games.length > 0
    end

    context "when calling the first venue" do
      setup do
        @venue = @schedule.venues.first
      end

      should "have many games" do
        assert @venue.games.length > 0
        assert_kind_of MLB::Game, @venue.games.first
      end
    end

    context "when calling the first game" do
      setup do
        @game = @schedule.games.first
      end

      should "have a numeric id" do
        assert_not_nil @game.id
        assert_kind_of Integer, @game.id
      end

      should "have a home team" do
        assert_not_nil @game.home_team
        assert_kind_of MLB::Team, @game.home_team
      end

      should "have a visiting team" do
        assert_not_nil @game.visiting_team
        assert_kind_of MLB::Team, @game.visiting_team
      end

      should "have a game time" do
        assert_kind_of Time, @game.starts_at
      end

      should "have a venue" do
        assert_kind_of MLB::Venue, @game.venue
      end

    end

    context "when adding to the schedule" do
      setup do
        @games_length = @schedule.games.length
        @schedule.add(File.read("test/fixtures/2009-07-10.xml"))
      end

      should "have more games" do
        assert @games_length < @schedule.games.length
      end
    end

  end

end
