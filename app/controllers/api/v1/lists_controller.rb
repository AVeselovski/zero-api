# frozen_string_literal: true

class Api::V1::ListsController < ApiController
  before_action do
    require_board_user(params[:board_id])
  end
  before_action :set_board
  before_action :set_list, only: [:show, :update, :destroy, :move]

  invalid_token = '"Invalid authentication token!" - User in not loggen in'
  no_access = '"No access!" - User has no access to a resource / resource doesn\'t exist'
  not_found = "Not found"
  param_error = "Invalid parameters. Apipie errors"

  api :GET, "/v1/boards/:board_id/lists", "JWT REQUIRED: Get all board lists"
  formats ["json"]
  param :board_id, String, "Board id", required: true
  example " 200: [{ 'id': 1, 'name': 'List name', 'position': 1, 'board': {...}, 'cards': [] }, {...}] "
  error code: 401, desc: invalid_token
  error code: 403, desc: no_access
  def index
    @lists = @board.lists.sorted

    render json: @lists
  end

  api :GET, "/v1/boards/:board_id/lists/:id", "JWT REQUIRED: Get a list"
  formats ["json"]
  param :board_id, String, "Board id", required: true
  param :id, String, "List id", required: true
  example " 200: { 'id': 1, 'name': 'List name', 'position': 1, 'board': {...}, 'cards': [] } "
  error code: 401, desc: invalid_token
  error code: 403, desc: no_access
  error code: 404, desc: not_found
  def show
    render json: @list
  end

  api :POST, "/v1/boards/:board_id/lists", "JWT REQUIRED: Create new list"
  formats ["json"]
  param :board_id, String, "Board id", required: true
  param :list, Hash, "Request {}", required: true do
    param :name, String, "List name", required: true
  end
  example " REQUEST JSON: { 'name': 'List name' } "
  example " 201: { 'id': 1, 'name': 'List name', 'position': 1, 'board': {...}, 'cards': [] } "
  error code: 401, desc: invalid_token
  error code: 403, desc: no_access
  error code: 422, desc: param_error
  def create
    @list = @board.lists.build(list_params)

    if @list.save
      render json: @list, status: :created
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  api :PUT, "/v1/boards/:board_id/lists/:id", "JWT REQUIRED: Update list"
  formats ["json"]
  param :board_id, String, "Board id", required: true
  param :id, String, "List id", required: true
  param :list, Hash, "Request {}", required: true do
    param :name, String, "List name", required: true
  end
  example " REQUEST JSON: { 'name': 'Updated list name' } "
  example " 200: { 'id': 1, 'name': 'Updated list name', 'position': 1, 'board': {...}, 'cards': [] } "
  error code: 401, desc: invalid_token
  error code: 403, desc: no_access
  error code: 404, desc: not_found
  error code: 422, desc: param_error
  def update
    if @list.update(list_params)
      render json: @list
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, "/v1/boards/:board_id/lists/:id", "JWT REQUIRED: Delete list"
  formats ["json"]
  param :board_id, String, "Board id", required: true
  param :id, String, "List id", required: true
  example " 204: no content "
  error code: 401, desc: invalid_token
  error code: 403, desc: no_access
  error code: 404, desc: not_found
  def destroy
    @list.destroy
  end

  api :PATCH, "/v1/boards/:board_id/lists/:id/move", "JWT REQUIRED: Update list position"
  formats ["json"]
  param :board_id, String, "Board id", required: true
  param :id, String, "List id", required: true
  param :list, Hash, "Request {}", required: true do
    param :position, :number, "Position index", required: true
  end
  example " REQUEST JSON: { 'position': 2 } "
  example " 200: { 'id': 1, 'name': 'List name', 'position': 2, 'board': {...}, 'cards': [] } "
  error code: 401, desc: invalid_token
  error code: 403, desc: no_access
  error code: 404, desc: not_found
  error code: 422, desc: param_error
  def move
    # acts_as_list method
    @list.insert_at(list_params[:position].to_i)

    render json: @list
  end

  private
    def set_board
      @board = current_user.boards.find(params[:board_id])
    end

    def set_list
      @list = List.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def list_params
      params.require(:list).permit(:name, :position, :board_id)
    end
end
