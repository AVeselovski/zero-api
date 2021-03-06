# frozen_string_literal: true

class ListSerializer < ActiveModel::Serializer
  attributes :id, :board_id, :name, :position

  belongs_to :board
  has_many :cards
end
