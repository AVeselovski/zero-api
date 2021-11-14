# frozen_string_literal: true

class Api::V1::BoardsController < ApiController
  before_action except: [:index, :create] do
    require_board_user(params[:id])
  end
  before_action :set_board, only: [:show, :update, :destroy, :add_user, :remove_user]

  invalid_token = '"Invalid authentication token! / Expired token!" - User in not loggen in'
  no_access = '"No access!" - User has no access to a resource / resource doesn\'t exist'
  param_error = "Invalid parameters. Apipie errors"

  api :GET, "/v1/boards", "JWT REQUIRED: Get all users boards"
  formats ["json"]
  example " 200: [{ 'id': 1, 'name': 'Board name', 'ownerId': 1, 'lists': [], 'users': [...] }, {...}] "
  error code: 401, desc: invalid_token
  def index
    @boards = current_user.boards
    render json: @boards
  end

  api :GET, "/v1/boards/:id", "JWT REQUIRED: Get user board"
  formats ["json"]
  param :id, String, "Board id", required: true
  example " 200: { 'id': 1, 'name': 'Board name', 'ownerId': 1, 'lists': [], 'users': [...] } "
  error code: 401, desc: invalid_token
  error code: 403, desc: no_access
  def show
    render json: @board
  end

  api :POST, "/v1/boards", "JWT REQUIRED: Create new board"
  formats ["json"]
  param :board, Hash, "Request {}", required: true do
    param :name, String, "Board name", required: true
  end
  example " REQUEST JSON: { 'name': 'Board name' } "
  example " 201: { 'id': 1, 'name': 'Board name', 'ownerId': 1, 'lists': [], 'users': [...] } "
  error code: 401, desc: invalid_token
  error code: 422, desc: param_error
  def create
    board = Board.new(board_params)
    board[:owner_id] = current_user[:id]

    if board.save
      board.users << current_user
      render json: board, status: :created
    else
      render json: board.errors, status: :unprocessable_entity
    end
  end

  api :PUT, "/v1/boards/:id", "JWT REQUIRED: Update board"
  formats ["json"]
  param :id, String, "Board id", required: true
  param :board, Hash, "Request {}", required: true do
    param :name, String, "Board name", required: true
  end
  example " REQUEST JSON: { 'name': 'Updated board name' } "
  example " 200: { 'id': 1, 'name': 'Updated board name', 'ownerId': 1, 'lists': [], 'users': [...] } "
  error code: 401, desc: invalid_token
  error code: 403, desc: no_access
  error code: 422, desc: param_error
  def update
    if @board.update(board_params)
      render json: @board
    else
      render json: @board.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, "/v1/boards/:id", "JWT REQUIRED: Delete board"
  formats ["json"]
  param :id, String, "Board id", required: true
  example " 204: no content "
  error code: 401, desc: invalid_token
  error code: 403, desc: no_access
  def destroy
    @board.destroy
  end

  api :PUT, "/v1/boards/:id/add_user", "JWT REQUIRED: Add user to board"
  formats ["json"]
  param :id, String, "Board id", required: true
  param :user_id, :number, "User id", required: true
  example " REQUEST JSON: { 'userId': 2 } "
  example " 200: { 'id': 1, 'name': 'Board name', 'ownerId': 1, 'lists': [], 'users': [...] } "
  error code: 401, desc: invalid_token
  error code: 403, desc: '"Only the board owner can add/remove members!"'
  error code: 404, desc: '"User doesn\'t exist!"'
  error code: 422, desc: param_error
  error code: 422, desc: '"User is already a member!"'
  def add_user
    if current_user[:id] != @board[:owner_id]
      render json: { errors: ["Only the board owner can add/remove members!"] }, status: :forbidden
      return
    end

    user_exists = @board.users.exists?(params[:user_id])
    if user_exists
      render json: { errors: ["User is already a member!"] }, status: :unprocessable_entity
      return
    end

    new_user = User.find_by(id: params[:user_id])
    if !new_user
      render json: { errors: ["User doesn't exist!"] }, status: :not_found
      return
    end

    @board.users << new_user
    render json: @board, status: :ok
  end

  api :DELETE, "/v1/boards/:id/add_user", "JWT REQUIRED: Remove user from board"
  formats ["json"]
  param :id, String, "Board id", required: true
  param :user_id, :number, "User id", required: true
  example " REQUEST JSON: { 'userId': 2 } "
  example " 200: { 'id': 1, 'name': 'Board name', 'ownerId': 1, 'lists': [], 'users': [...] } "
  error code: 401, desc: invalid_token
  error code: 403, desc: '"Only the board owner can add/remove members!"'
  error code: 404, desc: '"User doesn\'t exist!"'
  error code: 422, desc: param_error
  error code: 422, desc: '"Cannot remove the only member, try archiving the board!"'
  def remove_user
    if current_user[:id] != @board[:owner_id]
      render json: { errors: ["Only the board owner can add/remove members!"] }, status: :forbidden
      return
    end

    if @board.users.count == 1
      render json: { errors: ["Cannot remove the only member, try archiving the board!"] }, status: :unprocessable_entity
      return
    end

    if params[:user_id] == @board[:owner_id]
      @board.users.delete(current_user)
      next_board_owner_id = @board.users.first[:id]
      @board[:owner_id] = next_board_owner_id

      if @board.save
        render json: @board, status: :ok
        return
      else
        render json: @board.errors, status: :unprocessable_entity
        return
      end
    end

    removed_user = User.find_by(id: params[:user_id])
    if !removed_user
      render json: { errors: ["User doesn't exist!"] }, status: :not_found
      return
    end

    @board.users.delete(removed_user)
    render json: @board, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_board
      @board = current_user.boards.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def board_params
      params.require(:board).permit(:name)
    end
end
