defmodule Infkeeper.Authentication do
  import Ecto.Query, warn: false
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  
  alias Infkeeper.Repo
  alias Infkeeper.Accounts.User
  alias Infkeeper.Authentication.Guardian

  def get_user_by_token(token), do: Guardian.resource_from_token(token)

  def token_sign_in(email, password) do
    case authenticate_user_by_email_and_password(email, password) do
      {:ok, user} -> generate_token(user)
      _ -> {:error, :unauthorized}
    end
  end

  defp authenticate_user_by_email_and_password(email, password) do
    with {:ok, user} <- get_user_by_email(email) do
      verify_password(password, user)
    end
  end

  defp get_user_by_email(email) do
    case Repo.get_by(User, email: email) do
      nil ->
        dummy_checkpw()
        {:error, :not_found}
      user ->
        {:ok, user}
    end
  end

   defp verify_password(password, %User{} = user) do
    if checkpw(password, user.password_hash) do
      {:ok, user}
    else
      {:error, :invalid_password}
    end
  end

  defp generate_token(user) do
    {:ok, token, _claims} = Guardian.encode_and_sign(user)
    {:ok, token}
  end
end
