defmodule Mnemosyne.Authentication.Guardian do
  @moduledoc false
  use Guardian, otp_app: :mnemosyne

  alias Mnemosyne.Accounts

  def subject_for_token(user, _claims) do
    sub = to_string(user.id)
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = Accounts.get_user!(id)
    {:ok, resource}
  end
end
