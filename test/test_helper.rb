# frozen_string_literal: true

require "simplecov"
SimpleCov.start "rails" do
  add_filter "bin/spring"
  add_filter "app/channels"
  add_filter "app/jobs/application_job.rb"
  add_filter "app/mailers/application_mailer.rb"
  add_filter "app/serializers" # shows 100% without tests?
  add_filter "app/models" # shows 100% without tests? Y u hate me, Rails?
end

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # parallelize(workers: :number_of_processors)

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
    boards(:jane_board).owner_id = user_jane.id
    boards(:jane_board).save
    boards(:john_board).owner_id = user_john.id
    boards(:john_board).save
    boards(:common_board).owner_id = user_jane.id
    boards(:common_board).save
  end

  def get_token(user)
    JsonWebToken.encode(sub: user.id)
  end
end
