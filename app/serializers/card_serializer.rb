class CardSerializer < ActiveModel::Serializer
  attributes :id, :name, :position

  belongs_to :list
end
