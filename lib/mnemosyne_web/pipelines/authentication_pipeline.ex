defmodule MnemosyneWeb.AuthenticationPipeline do
  @moduledoc """
  Verifies whether a request is authenticated or not
  """
  use Guardian.Plug.Pipeline,
    otp_app: :mnemosyne,
    module: Mnemosyne.Authentication.Guardian

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.VerifySession
end
