# frozen_string_literal: true

class Api::V1::UsersController < ApiController
  api :GET, "/v1/me", "PROTECTED: Get user information"
  formats ["json"]
  example " 200: { 'id': 1, 'email': 'example@example.com', 'username': 'Example', 'boards': [...] } "
  error code: 401, desc: ERROR_MESSAGES[:apipie_invalid_token]
  def get_user
    render json: @current_user
  end
end
