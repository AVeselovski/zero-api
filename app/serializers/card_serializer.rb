# frozen_string_literal: true

class CardSerializer < ActiveModel::Serializer
  attributes :id, :name, :position, :list_id

  belongs_to :list
end
