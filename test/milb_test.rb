require File.dirname(__FILE__) + "/test_helper.rb"

class MILB_Test < Test::Unit::TestCase

  context "An MILB schedule" do
    setup do
      @schedule = MILB::Schedule.new(File.read('test/fixtures/schedule_01.xml'))
    end

    should "have 16 games" do
      assert_equal 16, @schedule.games.length
    end

    should "have 8 teams" do
      assert_equal 8, @schedule.teams.length
    end

    should "have 8 venues" do
      assert_equal 8, @schedule.venues.length
    end

    context "when calling the first venue" do
      setup do
        @venue = @schedule.venues.first
      end

      should "be named" do
        assert_equal "Drillers Stadium", @venue.name
      end

      should "have many games" do
        assert @venue.games.length > 0
        assert_kind_of MILB::Game, @venue.games.first
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
        assert_kind_of MILB::Team, @game.home_team
      end

      should "have a visiting team" do
        assert_not_nil @game.visiting_team
        assert_kind_of MILB::Team, @game.visiting_team
      end

      should "have a game time" do
        assert_kind_of Time, @game.starts_at
      end

      should "have a venue" do
        assert_kind_of MILB::Venue, @game.venue
      end

    end

    context "when calling the first team" do
      setup do
        @team = @schedule.teams.first
      end

      should "be named" do
        assert_equal "Tulsa Drillers", @team.name
      end

      should "have 4 game" do
        assert_equal 4, @team.games.length
        @team.games { | game | assert_kind_of MILB::Game, game } 
      end

      should "have an id that is not blank" do
        assert_kind_of Integer, @team.id
        assert_not_nil @team.id
      end
    end

    context "when adding to the schedule" do
      setup do
        @games_length = @schedule.games.length
        @schedule.add(File.read("test/fixtures/schedule_02.xml"))
      end

      should "have 35 games" do
        assert_equal 35, @schedule.games.length
      end

      should "have 18 teams" do
        assert_equal 18, @schedule.teams.length
      end

      should "have 17 venues" do
        assert_equal 17, @schedule.venues.length
      end

      context "when calling the first team" do
        setup do
          @team = @schedule.teams.first
        end

        should "have 4 games" do
          assert_equal 4, @team.games.length
          @team.games { | game | assert_kind_of MILB::Game, game } 
        end
      end
    end

    context "and I add the same schedule" do
      setup do
        @games_length = @schedule.games.length
        @teams_length = @schedule.teams.length
        @venues_length = @schedule.venues.length
        @schedule.add(File.read("test/fixtures/schedule_01.xml"))
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

        should "have 4 games" do
          assert_equal 4, @team.games.length
          @team.games { | game | assert_kind_of MILB::Game, game } 
        end
      end
    end

  end

end
