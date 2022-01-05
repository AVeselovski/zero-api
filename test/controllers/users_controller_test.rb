# frozen_string_literal: true

require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    create_relationships

    user = users(:user_jane)
    token = get_token(user)
    @auth = "Bearer #{token}"
  end

  test "should get user information" do
    get api_v1_me_path, headers: { authorization: @auth }, as: :json
    json_response = JSON.parse(response.body)

    assert json_response["id"] == users(:user_jane).id
    assert_response :success
  end
end
