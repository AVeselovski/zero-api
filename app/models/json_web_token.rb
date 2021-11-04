# frozen_string_literal: true

class JsonWebToken
  def self.encode(payload)
    expiration = Time.now.to_i + 24 * 3600 # 24 hours
    JWT.encode payload.merge(exp: expiration), Rails.application.secrets.secret_key_base
  end

  def self.decode(token)
    JWT.decode(token, Rails.application.secrets.secret_key_base).first
  end
end
