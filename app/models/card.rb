# frozen_string_literal: true

class Card < ApplicationRecord
  acts_as_list scope: :list

  belongs_to :list

  validates :name,
            presence: true,
            length: { minimum: 1, maximum: 50 }
end
