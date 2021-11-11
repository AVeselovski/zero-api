# frozen_string_literal: true

require "test_helper"

class BoardTest < ActiveSupport::TestCase
  def setup
    @board = Board.new(
      name: "Test board"
    )
  end

  test "board should be valid" do
    assert @board.valid?
    assert @board.save
  end

  test "name should be present" do
    @board.name = " "

    assert_not @board.valid?
    assert_not @board.save
  end

  test "name should not be too short" do
    @board.name = "X"

    assert_not @board.valid?
    assert_not @board.save
  end

  test "name should not be too long" do
    @board.name = "The great project of big importance"

    assert_not @board.valid?
    assert_not @board.save
  end
end
