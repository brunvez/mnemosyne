defmodule InfkeeperWeb.AuthenticationPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :messaging,
    module: Infkeeper.Authentication.Guardian,
    error_handler: MessagingWeb.Authentication.ErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
  plug InfkeeperWeb.Authentication.SetCurrentUser
end