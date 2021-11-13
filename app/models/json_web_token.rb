# frozen_string_literal: true

class JsonWebToken
  def self.encode(payload)
    expiration = Time.now.to_i + 24 * 3600 # 24 hours
    JWT.encode payload.merge(exp: expiration), ENV["JWT_SECRET_KEY"]
  end

  def self.decode(token)
    JWT.decode(token, ENV["JWT_SECRET_KEY"]).first
  end
end
