# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :board_users, dependent: :destroy
  has_many :boards, through: :board_users

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
end
