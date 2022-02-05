# frozen_string_literal: true

class CardSerializer < ActiveModel::Serializer
  attributes :id, :list_id, :name, :body, :position

  belongs_to :list
end
