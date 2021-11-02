class Api::V1::ListsController < ApplicationController
  before_action :set_board
  before_action :set_list, only: [:show, :update, :destroy]

  # GET /boards/1/lists
  def index
    @lists = @board.lists.sorted

    render json: @lists
  end

  # GET /boards/1/lists/1
  def show
    render json: @list
  end

  # POST /boards/1/lists
  def create
    @list = @board.lists.build(list_params)

    if @list.save
      render json: @list, status: :created
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /boards/1/lists/1
  def update
    if @list.update(list_params)
      render json: @list
    else
      render json: @list.errors, status: :unprocessable_entity
    end
  end

  # DELETE /boards/1/lists/1
  def destroy
    @list.destroy
  end

  private

  def set_board
    @board = Board.find(params[:board_id])
  end

  def set_list
    @list = List.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def list_params
    params.require(:list).permit(:name, :position, :board_id)
  end
end
