defmodule ExampleLiveViewApp.Repo do
  use Ecto.Repo,
    otp_app: :example_live_view_app,
    adapter: Ecto.Adapters.Postgres
end
