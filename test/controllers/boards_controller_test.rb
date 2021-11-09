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
end
