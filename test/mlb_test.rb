require File.expand_path(File.dirname(__FILE__)) + "/test_helper.rb"

class MLB_Test < Test::Unit::TestCase

  context "An MLB schedule" do
    setup do
      @schedule = MLB::Schedule.new(File.read(xml_path('/fixtures/2009-07-09.xml')))
    end

    should "have 13 games" do
      assert_equal 13, @schedule.games.length
    end

    should "have 24 teams" do
      assert_equal 24, @schedule.teams.length
    end

    should "have 13 venues" do
      assert_equal 13, @schedule.venues.length
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

    context "when calling the first team" do
      setup do
        @team = @schedule.teams.first
      end

      should "have 1 game" do
        assert_equal 1, @team.games.length
        @team.games { | game | assert_kind_of MLB::Game, game }
      end
    end

    context "when adding to the schedule" do
      setup do
        @games_length = @schedule.games.length
        @schedule.add(File.read(xml_path("/fixtures/2009-07-10.xml")))
      end

      should "have 28 games" do
        assert_equal 28, @schedule.games.length
      end

      should "have 30 teams" do
        assert_equal 30, @schedule.teams.length
      end

      should "have 17 venues" do
        assert_equal 17, @schedule.venues.length
      end

      context "when calling the first team" do
        setup do
          @team = @schedule.teams.first
        end

        should "have 2 games" do
          assert_equal 2, @team.games.length
          @team.games { | game | assert_kind_of MLB::Game, game }
        end
      end
    end

    context "and I add the same schedule" do
      setup do
        @games_length = @schedule.games.length
        @teams_length = @schedule.teams.length
        @venues_length = @schedule.venues.length
        @schedule.add(File.read(xml_path("/fixtures/2009-07-09.xml")))
      end

      should "have the same number of venues" do
        assert_equal @venues_length, @schedule.venues.length
      end

      should "have the same number of games" do
        assert_equal @games_length, @schedule.games.length
      end

      should "have the same number of teams" do
        assert_equal @teams_length, @schedule.teams.length
      end

      context "when calling the first team" do
        setup do
          @team = @schedule.teams.first
        end

        should "have 1 games" do
          assert_equal 1, @team.games.length
          @team.games { | game | assert_kind_of MLB::Game, game }
        end
      end
    end

  end


end
