# frozen_string_literal: true

require "test_helper"

class BoardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    create_relationships

    user = users(:user_jane)
    token = get_token(user)
    @auth = "Bearer #{token}"
    @board = boards(:jane_board)
  end

  test "should get user boards" do
    get api_v1_boards_path, headers: { authorization: @auth }, as: :json
    json_response = JSON.parse(response.body)

    assert json_response.count == 2
    assert_response :success
  end

  test "should create board" do
    assert_difference("Board.count", 1) do
      post api_v1_boards_path,
           params: { board: { name: @board.name } },
           headers: { authorization: @auth },
           as: :json
    end
    assert_response 201
  end

  test "should show board" do
    get api_v1_board_path(@board), headers: { authorization: @auth }, as: :json

    assert_response :success
  end

  test "should not show board not belonging to user" do
    get api_v1_board_path(boards(:john_board)), headers: { authorization: @auth }, as: :json

    assert_response 403
  end

  test "should update board" do
    patch api_v1_board_path(@board),
          params: { board: { name: @board.name } },
          headers: { authorization: @auth },
          as: :json

    assert_response 200
  end

  test "should not update board not belonging to user" do
    patch api_v1_board_path(boards(:john_board)),
          params: { board: { name: @board.name } },
          headers: { authorization: @auth },
          as: :json

    assert_response 403
  end

  test "should destroy board" do
    assert_difference("Board.count", -1) do
      delete api_v1_board_path(@board), headers: { authorization: @auth }, as: :json
    end
    assert_response 204
  end

  test "should not destroy board not belonging to user" do
    assert_difference("Board.count", 0) do
      delete api_v1_board_path(boards(:john_board)), headers: { authorization: @auth }, as: :json
    end
    assert_response 403
  end

  test "should add users to board" do
    put add_user_api_v1_board_path(@board),
        params: { user_id: users(:user_john).id },
        headers: { authorization: @auth },
        as: :json

    assert @board.users.count == 2
    assert_response 201
  end

  test "should not add already added users to board" do
    put add_user_api_v1_board_path(boards(:common_board)),
        params: { user_id: users(:user_john).id },
        headers: { authorization: @auth },
        as: :json

    assert boards(:common_board).users.count == 2
    assert_response 422
  end

  test "should not add users to board if not board owner" do
    token = get_token(users(:user_john))
    auth = "Bearer #{token}"
    new_user = User.new({
      email: "test-o-man@test.com",
      username: "Test-o-Man",
      password: "password",
      password_confirmation: "password"
    })
    new_user.save

    put add_user_api_v1_board_path(boards(:common_board)),
        params: { user_id: new_user.id },
        headers: { authorization: auth },
        as: :json

    assert @board.users.count == 1
    assert_response 403
  end

  test "should remove users from board" do
    delete remove_user_api_v1_board_path(boards(:common_board)),
           params: { user_id: users(:user_john).id },
           headers: { authorization: @auth },
           as: :json

    assert @board.users.count == 1
    assert_response 200
  end

  test "should not remove users from board if not board owner" do
    token = get_token(users(:user_john))
    auth = "Bearer #{token}"

    delete remove_user_api_v1_board_path(boards(:common_board)),
           params: { user_id: users(:user_jane).id },
           headers: { authorization: auth },
           as: :json

    assert boards(:common_board).users.count == 2
    assert_response 403
  end

  test "should not remove the only user from board" do
    delete remove_user_api_v1_board_path(@board),
           params: { user_id: users(:user_jane).id },
           headers: { authorization: @auth },
           as: :json

    assert @board.users.count == 1
    assert_response 422
  end

  test "should transfer ownership when owner removed" do
    delete remove_user_api_v1_board_path(boards(:common_board)),
           params: { user_id: users(:user_jane).id },
           headers: { authorization: @auth },
           as: :json

    json_response = JSON.parse(response.body)

    assert boards(:common_board).users.count == 1
    assert json_response["ownerId"] == users(:user_john).id
    assert_response 200
  end
end

# json_response = JSON.parse(response.body)
