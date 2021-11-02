class BoardSerializer < ActiveModel::Serializer
  attributes :id, :name

  has_many :lists
end
