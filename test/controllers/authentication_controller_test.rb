# frozen_string_literal: true

require "test_helper"

class AuthenticationControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = {
      email: "test-o-man@test.com",
      username: "Test-o-Man",
      password: "password",
      password_confirmation: "password"
    }
  end

  test "should create JWT token and respond 200 with token" do
    post api_v1_auth_login_path, params: { email: "jane.tester@test.com", password: "password" }
    json_response = JSON.parse(response.body)

    assert json_response.key?("token")
    assert_response 200
  end

  test "should not create token and respond 401 if wrong email" do
    post api_v1_auth_login_path, params: { email: "jane.tester@wrong-mail.com", password: "password" }
    json_response = JSON.parse(response.body)

    assert_not json_response.key?("token")
    assert_response 401
  end

  test "should not create token and respond 401 if wrong password" do
    post api_v1_auth_login_path, params: { email: "jane.tester@test.com", password: "wrong-password" }
    json_response = JSON.parse(response.body)

    assert_not json_response.key?("token")
    assert_response 401
  end

  test "should create new user and respond 201 with JWT token" do
    assert_difference("User.count", 1) do
      post api_v1_auth_register_path, params: { **@user }
    end

    json_response = JSON.parse(response.body)

    assert json_response.key?("token")
    assert_response 201
  end

  test "should not create user and respond 400 if existing email" do
    @user[:email] = "jane.tester@test.com"

    assert_difference("User.count", 0) do
      post api_v1_auth_register_path, params: { **@user }
    end

    json_response = JSON.parse(response.body)

    assert_not json_response.key?("token")
    assert_response 400
  end

  test "should not create user and respond 400 if existing username" do
    @user[:username] = "Jane"

    assert_difference("User.count", 0) do
      post api_v1_auth_register_path, params: { **@user }
    end

    json_response = JSON.parse(response.body)

    assert_not json_response.key?("token")
    assert_response 400
  end

  test "should not create user and respond 400 if mismatching passwords" do
    @user[:password_confirmation] = "passw0rd"

    assert_difference("User.count", 0) do
      post api_v1_auth_register_path, params: { **@user }
    end

    json_response = JSON.parse(response.body)

    assert_not json_response.key?("token")
    assert_response 400
  end
end
