# frozen_string_literal: true

class Api::V1::AuthenticationController < ApiController
  skip_before_action :authenticate_token!

  # login
  def create_token
    user = User.find_by(email: user_params[:email])
    if !user
      render json: { errors: ["Invalid username or password!"] }, status: :unauthorized
      return
    end
    if user.authenticate(user_params[:password])
      render json: { token: JsonWebToken.encode(sub: user.id) }, status: :ok
    else
      render json: { errors: ["Invalid username or password!"] }, status: :unauthorized
    end
  end

  # register
  def create_user
    existing_email = User.find_by(email: user_params[:email])
    existing_username = User.find_by(username: user_params[:username])
    if existing_email || existing_username
      render json: { errors: ["Email and / or username already taken!"] }, status: :bad_request
      return
    end

    if user_params[:password] != user_params[:password_confirmation]
      render json: { errors: ["Password mismatch!"] }, status: :bad_request
      return
    end

    user = User.new(user_params)
    if user.save
      render json: { token: JsonWebToken.encode(sub: user.id) }, status: :created
    else
      render json: { errors: ["Something went wrong!"] }, status: :bad_request
    end
  end

  private
    # Only allow a list of trusted parameters through.
    def user_params
      params.permit(:username, :email, :password, :password_confirmation)
    end
end
