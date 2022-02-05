# frozen_string_literal: true

class BoardSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :owner_id

  has_many :lists
  has_many :users
end
