defmodule ExampleLiveViewAppWeb.DimmerComponent do
  use ExampleLiveViewAppWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div id="dimmer_<%= @dimmer.id%>"class="rounded overflow-hidden shadow-md p-4">
      <div class="flex max-w-full">
        <h3><%= @dimmer.name%></h3>
        <%= if @in_edition do %>
          <a class="mt-1 ml-auto" phx-click="put_to_edition" phx-value-type="dimmer" phx-value-id="<%=@dimmer.id%>">edit</a>
        <% end %>
      </div>
      <hr class="solid">
      <div class="grid grid-cols-2 grid-gap-2 p-2">
        <% path = if @dimmer.state, do: "images/icons/icons8_light_dimming_100_percent_96.png", else: "images/icons/icons8_light_dimming_off_96.png" %>
        <img class="max-h-20" src="<%= path %>">
        <% text = if @dimmer.state, do: "ON", else: "OFF" %>
        <button class="mt-3" type="button" phx-click="toggle" phx-target="<%= @myself %>"><%=text%></button>
      </div>
    <label> Brightness
      <input class="w-full" type="range"  value="<%= @dimmer.brightness %>" min="0" max="100" phx-keyup="brightness_changed" phx-click="brightness_changed" phx-target="<%= @myself %>">
    </label>
    <label> White 
      <input class="w-full" type="range"  value="<%= @dimmer.white%>" min="0" max="100" phx-keyup="white_changed" phx-click="white_changed" phx-target="<%= @myself %>">
    </label>
    <label> Color
      <input type="color" phx-target="<%= @myself %>"></input>
    </label>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event("toggle", _unsigned_params, socket) do
    dimmer = socket.assigns.dimmer
    send(self(), {:update_dimmer, dimmer.id, %{state: !dimmer.state}})
    {:noreply, socket}
  end

  @impl true
  def handle_event("brightness_changed", %{"value" => value}, socket) do
    {brightness, ""} = Integer.parse(value)
    dimmer = socket.assigns.dimmer
    send(self(), {:update_dimmer, dimmer.id, %{brightness: brightness}})
    {:noreply, socket}
  end

  @impl true
  def handle_event("white_changed", %{"value" => value}, socket) do
    dimmer = socket.assigns.dimmer
    send(self(), {:update_dimmer, dimmer.id, %{white: value}})
    {:noreply, socket}
  end
end
