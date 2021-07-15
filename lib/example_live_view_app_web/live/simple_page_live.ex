defmodule ExampleLiveViewAppWeb.SimplePageLive do
  use ExampleLiveViewAppWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, all_text: "All")}
  end
end
