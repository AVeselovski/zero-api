# frozen_string_literal: true

ERROR_MESSAGES = {
  invalid_credentials: "Invalid username or password!",
  invalid_token: "Invalid authentication token!",
  expired_token: "Expired token!",
  user_exists: "Email and / or username already taken!",
  password_mismatch: "Password mismatch!",
  no_access: "No access!",
  not_found: "Not found!",
  param_error: "Invalid parameters. Apipie errors.",
  generic: "Something went wrong!",
  apipie_invalid_token: '"Invalid authentication token! / Expired token!" - User is not loggen in',
  apipie_no_access: '"No access!" - User has no access to a resource / resource doesn\'t exist',
}.freeze
