defmodule PingCRM.Core.Accounts.UserAuth do
  alias PingCRM.Core.Repo
  alias PingCRM.Core.Accounts.User

  def get_user_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    user = Repo.get_by(User, email: email)
    if valid_password?(user, password), do: user
  end

  # Verifies the password.
  #
  # If there is no user or the user doesn't have a password, we call
  # `Argon2.no_user_verify/0` to avoid timing attacks.
  defp valid_password?(%User{password_hash: password_hash}, password)
       when is_binary(password_hash) and byte_size(password) > 0 do
    Argon2.verify_pass(password, password_hash)
  end

  defp valid_password?(_, _) do
    Argon2.no_user_verify()
    false
  end
end
