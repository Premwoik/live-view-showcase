defmodule ExampleLiveViewAppWeb.CountersLive do
  use ExampleLiveViewAppWeb, :live_view

  @topic "counters:lobby"

  @impl true
  def mount(_params, _session, socket) do
    ExampleLiveViewAppWeb.Endpoint.subscribe(@topic)
    {:ok, assign(socket, counter_ids: [])}
  end

  @impl true
  def handle_event("add_counter", _unsigned_params, socket) do
    ids =  socket.assigns.counter_ids
    new_ids = [length(ids) | ids]
    ExampleLiveViewAppWeb.Endpoint.broadcast_from(self(), @topic, "update", %{counter_ids: new_ids})
    {:noreply, assign(socket, counter_ids: new_ids)}
  end

  @impl true
  def handle_event("remove_counter", _unsigned_params, socket) do
    ids = socket.assigns.counter_ids
    new_ids = tail(ids)
    ExampleLiveViewAppWeb.Endpoint.broadcast_from(self(), @topic, "update", %{counter_ids: new_ids})
    {:noreply, assign(socket, counter_ids: new_ids)}
  end

  @impl true
  def handle_event("reset_counters", _unsigned_params, socket) do
    Enum.each(socket.assigns.counter_ids, fn id ->
      ExampleLiveViewAppWeb.Endpoint.broadcast(@topic, "update_counter", %{id: id, value: 0})
    end)

    {:noreply, socket}
  end

  @impl true
  def handle_info(%{topic: @topic, event: "update", payload: %{counter_ids: ids}}, socket) do
    socket =
      put_flash(socket, :info, "Counters number updated!")
      |> assign(counter_ids: ids)

    {:noreply, socket}
  end

  @impl true
  def handle_info(%{topic: @topic, event: "update_counter", payload: %{id: id, value: value}}, socket) do

    send_update(ExampleLiveViewAppWeb.CounterComponent, id: id, value: value)

    socket =
      put_flash(socket, :info, "Updated counter #{id} with value #{value}!")

    {:noreply, socket}
  end

  def tail([]), do: []
  def tail([_ | t]), do: t
end
