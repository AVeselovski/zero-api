# frozen_string_literal: true

class ApiController < ApplicationController
  attr_reader :current_user

  # skip_before_action :verify_authenticity_token
  before_action :authenticate_token!

  private
    def authenticate_token!
      payload = JsonWebToken.decode(auth_token)
      if payload.present?
        @current_user = User.find(payload["sub"])
      else
        render json: { errors: ["Invalid authentication token!"] }, status: :unauthorized
      end
    rescue ActiveRecord::RecordNotFound
      render json: { errors: ["Invalid authentication token!"] }, status: :unauthorized
    rescue JWT::ExpiredSignature
      render json: { errors: ["Expired token!"] }, status: :unauthorized
    rescue JWT::DecodeError
      render json: { errors: ["Invalid authentication token!"] }, status: :unauthorized
    end

    def auth_token
      @auth_token ||= request.headers.fetch("Authorization", "").split(" ").last
    end
end
