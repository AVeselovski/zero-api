# frozen_string_literal: true

class Api::V1::CardsController < ApiController
  before_action do
    require_board_user(params[:board_id])
  end
  before_action :set_list
  before_action :set_card, only: [:show, :update, :destroy, :move]

  # GET .../1/lists/1/cards
  def index
    @cards = @list.cards

    render json: @cards
  end

  # GET .../1/lists/1/cards/1
  def show
    render json: @card
  end

  # POST .../1/lists/1/cards
  def create
    @card = @list.cards.build(card_params)

    if @card.save
      render json: @card, status: :created
    else
      render json: @card.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT .../1/lists/1/cards/1
  def update
    if @card.update(card_params)
      render json: @card
    else
      render json: @card.errors, status: :unprocessable_entity
    end
  end

  # DELETE .../1/lists/1/cards/1
  def destroy
    @card.destroy
  end

  # PATCH .../1/lists/1/cards/1/move
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
