# frozen_string_literal: true

require "test_helper"

class CardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    create_relationships

    user = users(:user_jane)
    token = get_token(user)
    @auth = "Bearer #{token}"
    @board = boards(:jane_board)
    @list = lists(:jane_board_list_1)
    @card = cards(1)
  end

  test "should get all list cards" do
    get api_v1_board_list_cards_path(@board, @list), headers: { authorization: @auth }, as: :json

    assert_response :success
  end

  test "should create card" do
    assert_difference("Card.count") do
      post api_v1_board_list_cards_path(@board, @list),
           params: { card: { list_id: @card.list_id, name: @card.name } },
           headers: { authorization: @auth },
           as: :json
    end
    assert_response 201
  end

  test "should show card" do
    get api_v1_board_list_card_path(@board, @list, @card), headers: { authorization: @auth }, as: :json

    assert_response :success
  end

  test "should update card" do
    put api_v1_board_list_card_path(@board, @list, @card),
        params: { card: { list_id: @card.list_id, name: @card.name } },
        headers: { authorization: @auth },
        as: :json

    assert_response 200
  end

  test "should destroy list" do
    assert_difference("Card.count", -1) do
      delete api_v1_board_list_card_path(@board, @list, @card), headers: { authorization: @auth }, as: :json
    end
    assert_response 204
  end

  test "should update card position" do
    patch move_api_v1_board_list_card_path(@board, @list, @card),
          params: { card: { position: 2 } },
          headers: { authorization: @auth },
          as: :json

    card_1 = Card.find(@card.id)
    card_2 = Card.find(cards(2).id)

    assert card_1.position == 2
    assert card_2.position == 1
    assert_response 200
  end

  test "should move card between lists" do
    second_list = lists(:jane_board_list_2)

    patch move_api_v1_board_list_card_path(@board, @list, @card),
          params: { card: { list_id: second_list.id, position: 1 } },
          headers: { authorization: @auth },
          as: :json

    card_1 = Card.find(@card.id)

    assert card_1.list_id == second_list.id
    assert card_1.position == 1
    assert second_list.cards.count == 2
    assert_response 200
  end

  test "users not assigned to board should not have access" do
    get api_v1_board_list_cards_path(boards(:john_board), lists(:john_board_list_1)), headers: { authorization: @auth }, as: :json

    assert_response 403
  end
end
