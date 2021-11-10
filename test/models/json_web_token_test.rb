# frozen_string_literal: true

require "test_helper"

class JsonWebTokenTest < ActiveSupport::TestCase
  USER_ID = 1

  test "should encode token" do
    token = JsonWebToken.encode(sub: USER_ID)

    assert token.is_a? String
  end

  test "should decode token" do
    token = JsonWebToken.encode(sub: USER_ID)
    decoded_token = JsonWebToken.decode(token)

    assert decoded_token.has_key?("sub")
  end
end
