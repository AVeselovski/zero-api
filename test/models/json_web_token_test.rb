# frozen_string_literal: true

require "test_helper"

class JsonWebTokenTest < ActiveSupport::TestCase
  USER_ID = 1
  TOKEN = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOjEsImV4cCI6MTYzNjU2NDkzMn0.dGJjMXL87FlU-ywDnH3aC_fRRsgOmqs6wBwfzSGFlH0"
  DECODED_TOKEN = { "sub" => 1, "exp" => 1636564932 }

  test "should encode token" do
    token = JsonWebToken.encode(sub: USER_ID)

    assert token.is_a? String
  end

  test "should decode token" do
    decoded_token = JsonWebToken.decode(TOKEN)

    assert_equal DECODED_TOKEN, decoded_token
  end
end
