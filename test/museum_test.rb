require 'minitest/autorun'
require 'minitest/pride'
require './lib/museum'
require './lib/patron'
require './lib/exhibit'

class MuseumTest < Minitest::Test
  def setup
    @dmns = Museum.new("Denver Museum of Nature and Science")

    @gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    @dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
    @imax = Exhibit.new({name: "IMAX",cost: 15})

    @patron_1 = Patron.new("Bob", 20)
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_1.add_interest("Gems and Minerals")

    @patron_2 = Patron.new("Sally", 20)
    @patron_2.add_interest("IMAX")

    @patron_3 = Patron.new("Johnny", 5)
    @patron_3.add_interest("Dead Sea Scrolls")
  end

  def test_it_has_attributes
    assert_equal "Denver Museum of Nature and Science", @dmns.name
  end

  def test_it_can_add_exhibits
    assert_empty @dmns.exhibits

    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    expected = [@gems_and_minerals, @dead_sea_scrolls, @imax]
    assert_equal expected, @dmns.exhibits
  end

  def test_it_can_recommend_exhibits_to_patrons
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    p1_expected = [@gems_and_minerals, @dead_sea_scrolls]

    assert_equal p1_expected, @dmns.recommend_exhibits(@patron_1)
    assert_equal [@imax], @dmns.recommend_exhibits(@patron_2)
  end

  def test_it_can_admit_patrons
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    assert_empty @dmns.patrons

    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)

    assert_equal [@patron_1, @patron_2, @patron_3], @dmns.patrons
  end

  def test_it_can_return_patrons_by_exhibit_interest
    patron_1 = Patron.new("Bob", 0)
    patron_1.add_interest("Gems and Minerals")
    patron_1.add_interest("Dead Sea Scrolls")

    patron_2 = Patron.new("Sally", 20)
    patron_2.add_interest("Dead Sea Scrolls")

    patron_3 = Patron.new("Johnny", 5)
    patron_3.add_interest("Dead Sea Scrolls")

    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    @dmns.admit(patron_1)
    @dmns.admit(patron_2)
    @dmns.admit(patron_3)

    expected = {
      @gems_and_minerals => [patron_1],
      @dead_sea_scrolls => [patron_1, patron_2, patron_3],
      @imax => []
    }
    @dmns.patrons_by_exhibit_interest
  end

  def test_ticket_lottery
    patron_1 = Patron.new("Bob", 0)
    patron_1.add_interest("Gems and Minerals")
    patron_1.add_interest("Dead Sea Scrolls")

    patron_2 = Patron.new("Sally", 20)
    patron_2.add_interest("Dead Sea Scrolls")

    patron_3 = Patron.new("Johnny", 5)
    patron_3.add_interest("Dead Sea Scrolls")

    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    @dmns.admit(patron_1)
    @dmns.admit(patron_2)
    @dmns.admit(patron_3)

    assert_equal [patron_1, patron_3], @dmns.ticket_lottery_contestants(@dead_sea_scrolls)


    # .stubs(:sample).returns("Johnny")
    # assert_equal 'Johnny', @dmns.draw_lottery_winner(@dead_sea_scrolls)

    assert_nil @dmns.draw_lottery_winner(@gems_and_minerals)

    # assert_equal "Bob has won the IMAX exhibit lottery", @dmns.announce_lottery_winner(@imax)
    # # The above string should match exactly, you will need to stub the return of `draw_lottery_winner` as the above method should depend on the return value of `draw_lottery_winner`.

    assert_equal "No winners for this lottery", @dmns.announce_lottery_winner(@gems_and_minerals)
  end
end
