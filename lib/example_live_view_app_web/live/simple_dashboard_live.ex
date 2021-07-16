defmodule ExampleLiveViewAppWeb.SimpleDashboardLive do
  use ExampleLiveViewAppWeb, :live_view

  alias ExampleLiveViewApp.Data.Dimmer
  alias ExampleLiveViewApp.Data.Light

  @impl true
  def mount(_params, _session, socket) do
    lights = Light.list_all()
    dimmers = Dimmer.list_all()

    {:ok,
     assign(socket, in_edition: false, item_create_data: %{}, lights: lights, dimmers: dimmers)}
  end

  @impl true
  def handle_event("edit", _unsigned_params, socket) do
    {:noreply, assign(socket, in_edition: true)}
  end

  @impl true
  def handle_event("abort_edit", _unsigned_params, socket) do
    {:noreply, assign(socket, item_create_data: %{}, in_edition: false)}
  end

  @impl true
  def handle_event("save", %{"item" => %{"id" => id, "item_type" => item_type} = item}, socket) do
    assigns =
      case {item_type, Integer.parse(id)} do
        {"light", :error} -> [lights: add_new_light(socket.assigns.lights, item)]
        {"dimmer", :error} -> [dimmers: add_new_dimmer(socket.assigns.dimmers, item)]
        {"light", {id, ""}} -> [lights: edit_exist_light(socket.assigns.lights, id, item)]
        {"dimmer", {id, ""}} -> [dimmers: edit_exist_dimmer(socket.assigns.dimmers, id, item)]
      end

    socket =
      put_flash(socket, :info, "Saved!")
      |> assign(assigns)
      |> assign(item_create_data: %{}, in_edition: false)

    {:noreply, socket}
  end

  @impl true
  def handle_event("remove_edited", _unsigned_params, socket) do
    item = socket.assigns.item_create_data
    id = item["id"]

    assigns =
      case item["item_type"] do
        "light" ->
          %Light{} = light = Enum.find(socket.assigns.lights, &(&1.id == id))
          {:ok, _} = Light.delete(light)
          [lights: List.delete(socket.assigns.lights, light)]

        "dimmer" ->
          %Dimmer{} = dimmer = Enum.find(socket.assigns.dimmers, &(&1.id == id))
          {:ok, _dimmer} = Dimmer.delete(dimmer)
          [dimmers: List.delete(socket.assigns.dimmers, dimmer)]
      end

    socket =
      put_flash(socket, :info, "Deleted!")
      |> assign(assigns)
      |> assign(item_create_data: %{}, in_edition: false)

    {:noreply, socket}
  end

  @impl true
  def handle_event("put_to_edition", %{"type" => type, "id" => id}, socket) do
    {id, ""} = Integer.parse(id)

    item =
      case type do
        "dimmer" -> Enum.find(socket.assigns.dimmers, %{}, &(&1.id == id))
        "light" -> Enum.find(socket.assigns.lights, %{}, &(&1.id == id))
        _ -> %{}
      end
      |> struct_to_map()
      |> Map.new(fn {k, v} -> {to_string(k), v} end)
      |> Map.put("item_type", type)

    {:noreply, assign(socket, item_create_data: item)}
  end

  @impl true
  def handle_event("type_selected", %{"item_create_data" => params}, socket) do
    {:noreply, assign(socket, item_create_data: params)}
  end

  @impl true
  def handle_event("toggle_light", %{"id" => id}, socket) do
    {id, ""} = Integer.parse(id)

    lights =
      socket.assigns.lights
      |> Enum.map(fn light ->
        if light.id == id do
          {:ok, updated_light} = Light.update(light, %{state: !light.state})
          updated_light
        else
          light
        end
      end)

    {:noreply, assign(socket, lights: lights)}
  end

  @impl true
  def handle_info({:update_dimmer, id, attrs}, socket) do
    dimmers =
      socket.assigns.dimmers
      |> Enum.map(fn d ->
        if d.id == id do
          {:ok, dimmer} = Dimmer.update(d, attrs)
          dimmer
        else
          d
        end
      end)

    {:noreply, assign(socket, dimmers: dimmers)}
  end

  def add_new_light(lights, params) do
    {:ok, light} = Light.insert(params)
    [light | lights]
  end

  def add_new_dimmer(dimmers, params) do
    {:ok, dimmer} = Dimmer.insert(params)
    [dimmer | dimmers]
  end

  def edit_exist_light(lights, id, params) do
    Enum.map(lights, fn l ->
      if l.id == id do
        {:ok, updated_light} = Light.update(l, params)
        updated_light
      else
        l
      end
    end)
  end

  def edit_exist_dimmer(dimmers, id, params) do
    Enum.map(dimmers, fn d ->
      if d.id == id do
        {:ok, updated_dimmer} = Dimmer.update(d, params)
        updated_dimmer
      else
        d
      end
    end)
  end

  def struct_to_map(%_{} = struct), do: Map.from_struct(struct)
  def struct_to_map(%{} = map), do: map
end
