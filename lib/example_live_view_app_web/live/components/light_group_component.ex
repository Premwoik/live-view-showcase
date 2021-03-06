defmodule ExampleLiveViewAppWeb.LightGroupComponent do
  use ExampleLiveViewAppWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div class="rounded overflow-hidden shadow-md p-4">
      <h3>Lights</h3>
      <hr class="solid">
      <%= for light <- @lights do %>
        <%= render(ExampleLiveViewAppWeb.DashboardView, "light.html", light: light, in_edition: @in_edition) %>
      <% end %>
    </div>    
    """
  end

  @impl true
  def mount(socket) do
    {:ok, assign(socket, value: 0)}
  end
end
