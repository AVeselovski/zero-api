# frozen_string_literal: true

class Api::V1::BoardsController < ApiController
  before_action except: [:index, :create] do
    require_board_user(params[:id])
  end
  before_action :set_board, only: [:show, :update, :destroy, :add_user, :remove_user]

  api :GET, "/v1/boards", "JWT PROTECTED: Get all users boards"
  def index
    @boards = current_user.boards

    render json: @boards
  end

  api :GET, "/v1/boards/:id", "JWT PROTECTED: Get user board"
  param :id, String, "Board id", required: true
  def show
    render json: @board
  end

  api :POST, "/v1/boards", "JWT PROTECTED: Create new board"
  param :board, Hash, "Request object", required: true do
    param :name, String, "Board name", required: true
  end
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

  api :PUT, "/v1/boards/:id", "JWT PROTECTED: Update board"
  param :id, String, "Board id", required: true
  param :board, Hash, "Request object", required: true do
    param :name, String, "Board name", required: true
  end
  def update
    if @board.update(board_params)
      render json: @board
    else
      render json: @board.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, "/v1/boards/:id", "JWT PROTECTED: Delete board"
  param :id, String, "Board id", required: true
  def destroy
    @board.destroy
  end

  api :PUT, "/v1/boards/:id/add_user", "JWT PROTECTED: Add user to board"
  param :id, String, "Board id", required: true
  param :user, Hash, "Request object", required: true do
    param :user_id, String, "User id", required: true
  end
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

    new_user = User.find(params[:user_id])
    @board.users << new_user

    render json: @board, status: :created
  end

  # DELETE /boards/1/remove_user
  api :DELETE, "/v1/boards/:id/add_user", "JWT PROTECTED: Remove user from board"
  param :id, String, "Board id", required: true
  param :user, Hash, "Request object", required: true do
    param :user_id, String, "User id", required: true
  end
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

    removed_user = User.find(params[:user_id])
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
