# frozen_string_literal: true

class User < ApplicationRecord
  has_many :board_users, dependent: :destroy
  has_many :boards, through: :board_users

  before_save { self.email = email.downcase }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :username,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 30 }
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { maximum: 80 },
            format: { with: VALID_EMAIL_REGEX }
  validates :password,
            presence: true,
            length: { minimum: 8 }

  has_secure_password
end
