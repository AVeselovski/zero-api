# frozen_string_literal: true

class ApiController < ApplicationController
  attr_reader :current_user

  # skip_before_action :verify_authenticity_token
  before_action :authenticate_token!

  # ParamError is superclass of ParamMissing, ParamInvalid
  rescue_from Apipie::ParamError do |e|
    render json: { errors: [e.message] }, status: :unprocessable_entity
  end

  def require_board_user(board_id)
    _board = current_user.boards.find(board_id)
  rescue ActiveRecord::RecordNotFound
    render json: { errors: [ERROR_MESSAGES[:no_access]] }, status: :forbidden
  end

  private
    def authenticate_token!
      payload = JsonWebToken.decode(auth_token)
      if payload.present?
        @current_user = User.find(payload["sub"])
      else
        render json: { errors: [ERROR_MESSAGES[:invalid_token]] }, status: :unauthorized
      end
    rescue ActiveRecord::RecordNotFound
      render json: { errors: [ERROR_MESSAGES[:invalid_token]] }, status: :unauthorized
    rescue JWT::ExpiredSignature
      render json: { errors: [ERROR_MESSAGES[:expired_token]] }, status: :unauthorized
    rescue JWT::DecodeError
      render json: { errors: [ERROR_MESSAGES[:invalid_token]] }, status: :unauthorized
    end

    def auth_token
      @auth_token ||= request.headers.fetch("Authorization", "").split(" ").last
    end
end
