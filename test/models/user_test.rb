# frozen_string_literal: true

require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(
      email: "test-o-man@test.com",
      username: "Test-o-Man",
      password: "password",
      password_confirmation: "password"
    )
  end

  test "user should be valid" do
    assert @user.valid?
  end

  test "username should be present" do
    @user.username = ""

    assert_not @user.valid?
  end

  test "username should not be too short" do
    @user.username = "TM"

    assert_not @user.valid?
  end

  test "username should not be too long" do
    @user.username = "JaneTesterTheGreatWhoTestsThemAll"

    assert_not @user.valid?
  end

  test "username should be unique" do
    @user.username = "Jane"

    assert_not @user.valid?
  end

  test "invalid email format should not be valid" do
    @user.email = "test.com"

    assert_not @user.valid?
  end

  test "too lengthy email should not be valid" do
    # odd fish filter
    @user.email = "a-very-long-name-that-is-unlikely-to-be-used.with-a-very-long-last-name@domain.com"

    assert_not @user.valid?
  end

  test "email should be unique" do
    @user.email = "jane.tester@test.com"

    assert_not @user.valid?
  end

  test "password should be present" do
    @user.password = ""
    @user.password_confirmation = ""

    assert_not @user.valid?
  end

  test "password should not be too short" do
    @user.password = "test"
    @user.password_confirmation = "test"

    assert_not @user.valid?
  end
end
