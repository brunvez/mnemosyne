defmodule MnemosyneWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  alias Ecto.Adapters.SQL.Sandbox, as: DatabaseAdapter
  alias Mnemosyne.Authentication.Guardian.Plug, as: AuthenticationPlug
  alias Mnemosyne.Authentication.Guardian
  alias Mnemosyne.UserFactory

  @default_opts [
    store: :cookie,
    key: "secretkey",
    encryption_salt: "encrypted cookie salt",
    signing_salt: "signing salt"
  ]
  @signing_opts Plug.Session.init(Keyword.put(@default_opts, :encrypt, false))

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      alias MnemosyneWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint MnemosyneWeb.Endpoint
    end
  end

  setup tags do
    :ok = DatabaseAdapter.checkout(Mnemosyne.Repo)

    unless tags[:async] do
      DatabaseAdapter.mode(Mnemosyne.Repo, {:shared, self()})
    end

    conn = Phoenix.ConnTest.build_conn()

    if tags[:browser_authenticated] || tags[:api_authenticated] do
      {:ok, conn, user} = authenticate(conn, tags)
      {:ok, conn: conn, user: user}
    else
      {:ok, conn: conn}
    end
  end

  defp authenticate(conn, %{browser_authenticated: _}) do
    authenticate_user_on_session(conn)
  end

  defp authenticate(conn, %{api_authenticated: _}) do
    authenticate_user_with_token(conn)
  end

  defp authenticate_user_on_session(conn) do
    user = UserFactory.create(:user)

    conn =
      conn
      |> Plug.Session.call(@signing_opts)
      |> Plug.Conn.fetch_session()
      |> AuthenticationPlug.sign_in(user)

    {:ok, conn, user}
  end

  defp authenticate_user_with_token(conn) do
    user = UserFactory.create(:user)
    {:ok, token, _claims} = Guardian.encode_and_sign(user)

    conn =
      conn
      |> Plug.Conn.put_req_header("authorization", "Bearer #{token}")

    {:ok, conn, user}
  end
end
