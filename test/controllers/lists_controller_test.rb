# frozen_string_literal: true

require "test_helper"

class ListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    create_relationships

    user = users(:user_jane)
    token = get_token(user)
    @auth = "Bearer #{token}"
    @board = boards(:jane_board)
    @list = lists(:jane_board_list_1)
  end

  test "should get all board lists" do
    get api_v1_board_lists_path(@board), headers: { authorization: @auth }, as: :json

    assert_response :success
  end

  test "should create list" do
    assert_difference("List.count") do
      post api_v1_board_lists_path(@board),
           params: { list: { board_id: @list.board_id, name: @list.name, position: @list.position } },
           headers: { authorization: @auth },
           as: :json
    end
    assert_response 201
  end

  test "should show list" do
    get api_v1_board_list_path(@board, @list), headers: { authorization: @auth }, as: :json

    assert_response :success
  end

  test "should update list" do
    put api_v1_board_list_path(@board, @list),
        params: { list: { board_id: @list.board_id, name: @list.name, position: @list.position } },
        headers: { authorization: @auth },
        as: :json

    assert_response 200
  end

  test "should destroy list" do
    assert_difference("List.count", -1) do
      delete api_v1_board_list_path(@board, @list), headers: { authorization: @auth }, as: :json
    end
    assert_response 204
  end

  test "should update list position" do
    patch move_api_v1_board_list_path(@board, @list),
          params: { list: { position: 2 } },
          headers: { authorization: @auth },
          as: :json

    list_1 = List.find(@list.id)
    list_2 = List.find(lists(:jane_board_list_2).id)

    assert list_1.position == 2
    assert list_2.position == 1
    assert_response 200
  end

  test "users not assigned to board should not have access" do
    get api_v1_board_lists_path(boards(:john_board)), headers: { authorization: @auth }, as: :json

    assert_response 403
  end
end
