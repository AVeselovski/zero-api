# frozen_string_literal: true

class Api::V1::CardsController < ApiController
  before_action do
    require_board_user(params[:board_id])
  end
  before_action :set_list
  before_action :set_card, only: [:show, :update, :destroy, :move]

  api :GET, "/v1/boards/:board_id/lists/:list_id/cards", "JWT REQUIRED: Get all list cards"
  formats ["json"]
  param :board_id, String, "Board id", required: true
  param :list_id, String, "List id", required: true
  example " 200: [{ 'id': 1, 'name': 'Card name', 'position': 1, 'listId': 1, 'list': {...} }, {...}] "
  error code: 401, desc: ERROR_MESSAGES[:apipie_invalid_token]
  error code: 403, desc: ERROR_MESSAGES[:apipie_no_access]
  def index
    @cards = @list.cards

    render json: @cards
  end

  api :GET, "/v1/boards/:board_id/lists/:list_id/cards/:id", "JWT REQUIRED: Get a card"
  formats ["json"]
  param :board_id, String, "Board id", required: true
  param :list_id, String, "List id", required: true
  param :id, String, "Card id", required: true
  example " 200: { 'id': 1, 'name': 'Card name', 'position': 1, 'listId': 1, 'list': {...} } "
  error code: 401, desc: ERROR_MESSAGES[:apipie_invalid_token]
  error code: 403, desc: ERROR_MESSAGES[:apipie_no_access]
  error code: 404, desc: ERROR_MESSAGES[:not_found]
  def show
    render json: @card
  end

  api :POST, "/v1/boards/:board_id/lists/:list_id/cards", "JWT REQUIRED: Create new card"
  formats ["json"]
  param :board_id, String, "Board id", required: true
  param :list_id, String, "List id", required: true
  param :card, Hash, "Request {}", required: true do
    param :name, String, "Card name", required: true
  end
  example " REQUEST JSON: { 'name': 'Card name' } "
  example " 201: { 'id': 1, 'name': 'Card name', 'position': 1, 'listId': 1, 'list': {...} } "
  error code: 401, desc: ERROR_MESSAGES[:apipie_invalid_token]
  error code: 403, desc: ERROR_MESSAGES[:apipie_no_access]
  error code: 422, desc: ERROR_MESSAGES[:param_error]
  def create
    @card = @list.cards.build(card_params)

    if @card.save
      render json: @card, status: :created
    else
      render json: @card.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT .../1/lists/1/cards/1
  api :PUT, "/v1/boards/:board_id/lists/:list_id/cards/:id", "JWT REQUIRED: Update card"
  formats ["json"]
  param :board_id, String, "Board id", required: true
  param :list_id, String, "List id", required: true
  param :id, String, "Card id", required: true
  param :card, Hash, "Request {}", required: true do
    param :name, String, "Card name", required: true
  end
  example " REQUEST JSON: { 'name': 'Updated card name' } "
  example " 200: { 'id': 1, 'name': 'Updated card name', 'position': 1, 'listId': 1, 'list': {...} } "
  error code: 401, desc: ERROR_MESSAGES[:apipie_invalid_token]
  error code: 403, desc: ERROR_MESSAGES[:apipie_no_access]
  error code: 404, desc: ERROR_MESSAGES[:not_found]
  error code: 422, desc: ERROR_MESSAGES[:param_error]
  def update
    if @card.update(card_params)
      render json: @card
    else
      render json: @card.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, "/v1/boards/:board_id/lists/:list_id/cards/:id", "JWT REQUIRED: Delete card"
  formats ["json"]
  param :board_id, String, "Board id", required: true
  param :list_id, String, "List id", required: true
  param :id, String, "Card id", required: true
  example " 204: no content "
  error code: 401, desc: ERROR_MESSAGES[:apipie_invalid_token]
  error code: 403, desc: ERROR_MESSAGES[:apipie_no_access]
  error code: 404, desc: ERROR_MESSAGES[:not_found]
  def destroy
    @card.destroy
  end

  api :PATCH, "/v1/boards/:board_id/lists/:list_id/cards/:id/move", "JWT REQUIRED: Update card position"
  formats ["json"]
  param :board_id, String, "Board id", required: true
  param :list_id, String, "List id", required: true
  param :id, String, "Card id", required: true
  param :card, Hash, "Request {}", required: true do
    param :position, :number, "Position index", required: true
  end
  example " REQUEST JSON: { 'position': 2 } "
  example " 200: { 'id': 1, 'name': 'Card name', 'position': 2, 'listId': 1, 'list': {...} } "
  error code: 401, desc: ERROR_MESSAGES[:apipie_invalid_token]
  error code: 403, desc: ERROR_MESSAGES[:apipie_no_access]
  error code: 404, desc: ERROR_MESSAGES[:not_found]
  error code: 422, desc: ERROR_MESSAGES[:param_error]
  def move
    @card.update(card_params)

    render json: @card
  end

  private
    def set_list
      @list = List.find(params[:list_id])
    end

    def set_card
      @card = @list.cards.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def card_params
      params.require(:card).permit(:name, :position, :list_id)
    end
end
