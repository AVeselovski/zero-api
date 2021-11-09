# frozen_string_literal: true

require "test_helper"

class ListTest < ActiveSupport::TestCase
  def setup
    @list = boards(:jane_board).lists.new(
      name: "New list"
    )
  end

  test "list should be valid" do
    assert @list.valid?
  end

  test "name should be present" do
    @list.name = " "

    assert_not @list.valid?
  end

  test "name should not be too long" do
    @list.name = "The great list of big importance that has a too long name"

    assert_not @list.valid?
  end
end
