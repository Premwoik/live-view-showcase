defmodule ExampleLiveViewAppWeb.CountersLive do
  use ExampleLiveViewAppWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, counter_ids: [])}
  end

  @impl true
  def handle_event("add_counter", _unsigned_params, socket) do
    ids = socket.assigns.counter_ids
    {:noreply, assign(socket, counter_ids: [length(ids) | ids])}
  end

  @impl true
  def handle_event("remove_counter", _unsigned_params, socket) do
    ids = socket.assigns.counter_ids
    {:noreply, assign(socket, counter_ids: tail(ids))}
  end

  @impl true
  def handle_event("reset_counters", _unsigned_params, socket) do
    Enum.each(socket.assigns.counter_ids, fn id ->
      send_update(ExampleLiveViewAppWeb.CounterComponent, id: id, value: 0)
    end)

    {:noreply, socket}
  end

  def tail([]), do: []
  def tail([_ | t]), do: t
end
