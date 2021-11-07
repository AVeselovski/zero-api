# frozen_string_literal: true

class BoardUser < ApplicationRecord
  belongs_to :board
  belongs_to :user
end
