# frozen_string_literal: true

require "test_helper"

class CardTest < ActiveSupport::TestCase
  def setup
    @card = lists(:jane_board_list_1).cards.new(
      name: "New list"
    )
  end

  test "card should be valid" do
    assert @card.valid?
    assert @card.save
  end

  test "name should be present" do
    @card.name = " "

    assert_not @card.valid?
    assert_not @card.save
  end

  test "name should not be too long" do
    @card.name = "The great card of big importance that has a too long name"

    assert_not @card.valid?
    assert_not @card.save
  end
end
