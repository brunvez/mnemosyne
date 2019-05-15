defmodule InfkeeperWeb.AuthenticationPipeline do
  @moduledoc """
  Verifies whether a request is authenticated or not 
  """
  use Guardian.Plug.Pipeline,
    otp_app: :infkeeper,
    module: Infkeeper.Authentication.Guardian

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.LoadResource, allow_blank: true
end
