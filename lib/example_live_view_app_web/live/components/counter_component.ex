defmodule ExampleLiveViewAppWeb.CounterComponent do
  use ExampleLiveViewAppWeb, :live_component

  @impl true
  def render(assigns) do
    ~L"""
    <div id="counter_<%=@id%>"class="rounded overflow-hidden shadow-md p-2">
      <h3>Counter <%=@id%></h3>
      <button type="button" phx-target="<%=@myself%>" phx-click="inc">Increase</button>
      <button type="button" phx-target="<%=@myself%>" phx-click="reset">Reset</button>
      <p><%=@value%></p>
    </div>
    """
  end

  @impl true
  def mount(socket) do
    IO.inspect(socket.assigns, label: "MOUNT")
    {:ok, assign(socket, value: 0)}
  end

  @impl true
  def preload(list_of_assigns) do
    IO.inspect(list_of_assigns, label: "PRELOAD")
    list_of_assigns
  end

  @impl true
  def update(assigns, socket) do
    IO.inspect(assigns, label: "UPDATE")
    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_event("inc", _unsigned_params, socket) do
    index = socket.assigns[:value] + 1
    {:noreply, assign(socket, value: index)}
  end

  @impl true
  def handle_event("reset", _unsigned_params, socket) do
    socket = put_flash(socket, :success, "Counter cleared!")
    {:noreply, assign(socket, value: 0)}
  end
end
