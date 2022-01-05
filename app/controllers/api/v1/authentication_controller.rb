# frozen_string_literal: true

class Api::V1::AuthenticationController < ApiController
  skip_before_action :authenticate_token!

  api :POST, "/v1/auth/login", "Log in / get JWT token."
  formats ["json"]
  param :email, String, "User email", required: true
  param :password, String, "User password", required: true
  example " REQUEST JSON: { 'email': 'example@test.com', 'password': 'password' } "
  example " 200: { 'token': 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOjIsImV4cCI6MTYzN...' } "
  error code: 401, desc: ERROR_MESSAGES[:invalid_credentials]
  error code: 422, desc: ERROR_MESSAGES[:param_error]
  def create_token
    user = User.find_by(email: user_params[:email])
    if !user
      render json: { errors: [ERROR_MESSAGES[:invalid_credentials]] }, status: :unauthorized
      return
    end
    if user.authenticate(user_params[:password])
      render json: { token: JsonWebToken.encode(sub: user.id) }, status: :ok
    else
      render json: { errors: [ERROR_MESSAGES[:invalid_credentials]] }, status: :unauthorized
    end
  end

  api :POST, "/v1/auth/register", "Create new user & get JWT token."
  formats ["json"]
  param :email, String, "Unique user email", required: true
  param :username, String, "Unique username", required: true
  param :password, String, "User password", required: true
  param :password_confirmation, String, "User password confirmation", required: true
  example "
    REQUEST JSON: {
      'email': 'example@test.com',
      'username': 'Example',
      'password': 'password',
      'passwordConfirmation': 'password'
    } "
  example " 201: { 'token': 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOjIsImV4cCI6MTYzN...' } "
  error code: 400, desc: ERROR_MESSAGES[:user_exists]
  error code: 400, desc: ERROR_MESSAGES[:password_mismatch]
  error code: 401, desc: ERROR_MESSAGES[:invalid_credentials]
  error code: 422, desc: ERROR_MESSAGES[:param_error]
  def create_user
    existing_email = User.find_by(email: user_params[:email])
    existing_username = User.find_by(username: user_params[:username])
    if existing_email || existing_username
      render json: { errors: [ERROR_MESSAGES[:user_exists]] }, status: :bad_request
      return
    end

    if user_params[:password] != user_params[:password_confirmation]
      render json: { errors: [ERROR_MESSAGES[:password_mismatch]] }, status: :bad_request
      return
    end

    user = User.new(user_params)
    if user.save
      render json: { token: JsonWebToken.encode(sub: user.id) }, status: :created
    else
      render json: { errors: [ERROR_MESSAGES[:generic]] }, status: :bad_request
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def user_params
      params.permit(:username, :email, :password, :password_confirmation)
    end
end
