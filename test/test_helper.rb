# frozen_string_literal: true

require "simplecov"
SimpleCov.start

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # Trying to setup relationships via fixtures causes this error, no matter what:
  #   "ActiveRecord::NotNullViolation: RuntimeError: NOT NULL constraint failed"
  # This is a working alternative
  def create_relationships
    user_jane = users(:user_jane)
    user_jane.boards.push(boards(:jane_board))
    user_jane.boards.push(boards(:common_board))
    user_john = users(:user_john)
    user_john.boards << boards(:john_board)
    user_john.boards << boards(:common_board)
  end

  def get_token(user)
    JsonWebToken.encode(sub: user.id)
  end
end
